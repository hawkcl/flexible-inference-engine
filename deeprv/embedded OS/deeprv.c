#include <linux/fs.h>
#include <linux/cdev.h>
#include <linux/uaccess.h>
#include <linux/init.h>
#include <linux/delay.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/irq.h>
#include <linux/irqchip.h>
#include <linux/irqdomain.h>
#include <asm/csr.h>
#include "rocc.h"

#define   DRV_DESCRIPTION   "deep_riscv"
#define   DRV_VERSION       "0.1"
#define   MAX_MEM_SIZE      1000000000

MODULE_DESCRIPTION(DRV_DESCRIPTION);
MODULE_AUTHOR("Lei Cheng <lcheng2@gmail.com>");
MODULE_VERSION(DRV_VERSION);
MODULE_LICENSE("Dual BSD/GPL");

// replace with standard _IO command
#define DEEPRV_CMD_ALLOC_FEATURE    1
#define DEEPRV_CMD_ALLOC_WEIGHT     2
#define DEEPRV_CMD_SEND_WEIGHT      3
#define DEEPRV_CMD_SEND_FEATURE     4
#define DEEPRV_CMD_START_COMPUTE    5
#define DEEPRV_CMD_SEND_BASE_ADDR   6
#define DEEPRV_CMD_START_READ       7
//TODO : add CMD pool, CMD copy , ....

// CMD sequence
//  1. open
//  2. ioctl DEEPRV_CMD_ALLOC_FEATURE
//  3. ioctl DEEPRV_CMD_ALLOC_WEIGHT
//  4. ioctl DEEPRV_CMD_SEND_BASE_ADDR
//  5. ioctl DEEPRV_CMD_SEND_WEIGHT
//  6. write
//  7. ioctl DEEPRV_CMD_SEND_FEATURE
//  8. write
//  9. ioctl DEEPRV_CMD_START_COMPUTE
//  10. ioctl DEEPRV_CMD_START_READ 
//  11. read
//  12. close or goto 7

static int deeprv_major = 240;
module_param(deeprv_major, int, S_IRUGO);

extern int rocc_irq;
extern struct irq_chip *riscv_chip0;

struct deeprv_dev{
    struct   cdev       cdev;
    unsigned char*      feature_addr;
    unsigned char*      weight_addr;
    unsigned            feature_size;
    unsigned            weight_size;
    unsigned            instruction_addr;
    unsigned            output_addr;
    unsigned            cur_pos;
    unsigned            interrupt_num;
    unsigned            read_num;
    unsigned            read_addr;
    spinlock_t          lock;
    unsigned char       is_sending_feature;

};
struct deeprv_dev  *deeprv_devp;

static inline void send_reset_cmd(void)
{
	asm volatile("fence");
	ROCC_INSTRUCTION_SS(2, 0, 0, 0);
    printk(KERN_INFO "reset cmd sent\n");
}
static inline void send_base_cmd(const unsigned char *f_adr, const unsigned char *w_adr)
{
	asm volatile("fence");
	ROCC_INSTRUCTION_SS(2, f_adr, w_adr, 2);
    printk(KERN_INFO "base cmd sent\n");
}
static inline void send_start_cmd(int adr)
{
	asm volatile("fence");
	ROCC_INSTRUCTION_SS(2, adr, 0, 1);
    printk(KERN_INFO "start cmd sent\n");
}

void enable_rocc_interrupt(void)
{
    csr_set(sie, (1 <<IRQ_COP));
    //csr_set(mie, (1 <<IRQ_COP));
    //csr_set(mstatus, MSTATUS_MIE);
}


void deeprv_interrupt_handle(struct irq_desc *desc)
{
    //raw_spin_lock(&desc->lock);
    spin_lock(&(deeprv_devp->lock));
    deeprv_devp->interrupt_num++;
    spin_unlock(&(deeprv_devp->lock));

//out_unlock:
    //raw_spin_unlock(&desc->lock);
}

int deeprv_open(struct inode *inode, struct file *filp)  
{  
    filp->private_data = deeprv_devp;  

    printk(KERN_INFO "deeprv opened\n");  
    return 0;  
}  
int deeprv_release(struct inode *inode, struct file *filp)  
{  
    return 0;  
}  

static long deeprv_ioctl(struct file *filp, unsigned  int cmd, unsigned long arg)  
{  

    struct deeprv_dev *dev = deeprv_devp;  
    //struct deeprv_dev *dev = filp->private_data;  
    //if(!dev){
     //   printk(KERN_NOTICE "no dev found for ioctl %d, %ld\n", cmd, arg);  
     //   return -1;
   // }
    //printk(KERN_INFO "ioctl %d, %ld, faddr %p, waddr %p\n", cmd, arg, dev->feature_addr, dev->weight_addr);  

    switch (cmd)  
    {  
        case DEEPRV_CMD_ALLOC_FEATURE:  break;
        case DEEPRV_CMD_ALLOC_WEIGHT:   break;
        case DEEPRV_CMD_SEND_WEIGHT:  
            dev->is_sending_feature = 0;
            dev->cur_pos = 0;
            break;
        case DEEPRV_CMD_SEND_FEATURE:  
            dev->is_sending_feature = 1;
            dev->cur_pos = 0;
            break;
        case DEEPRV_CMD_START_COMPUTE:  
            send_start_cmd((int )arg);
            break;
        case DEEPRV_CMD_SEND_BASE_ADDR:  
            break;
        case DEEPRV_CMD_START_READ:  
            break;

        default:  
            return  -1 ;  
    }
    return 0;
/*
    switch (cmd)  
    {  
        case DEEPRV_CMD_ALLOC_FEATURE:  
            //printk(KERN_INFO "feature asking size %ld\n",  arg);  
            //if(dev->feature_addr)
            //    kfree(dev->feature_addr);
            //dev->feature_addr = kmalloc(arg, GFP_KERNEL);       
            //dev->feature_size = arg;       
           // if(dev->feature_addr)
            //    printk(KERN_INFO "alloc feature address %p, size %ld\n", dev->feature_addr, arg);  
           // else{
             //   printk(KERN_NOTICE "alloc feature address failed, size %ld\n", arg);  
              //  return -ENOMEM;
            //}
            break;  
        case DEEPRV_CMD_ALLOC_WEIGHT:  
            printk(KERN_INFO "weight asking size %ld\n",  arg);  
            //if(dev->weight_addr)
            //    kfree(dev->weight_addr);
            //dev->weight_addr = kmalloc(arg, GFP_KERNEL);       
            dev->weight_size = arg;       
            if(dev->weight_addr)
                printk(KERN_INFO "alloc weight address %p, size %ld\n", dev->weight_addr, arg);  
            else{
                printk(KERN_NOTICE "alloc weight address failed, size %ld\n", arg);  
              //  return -ENOMEM;
            }
            break;  
        case DEEPRV_CMD_SEND_WEIGHT:  
            dev->is_sending_feature = 0;
            dev->cur_pos = 0;
            break;
        case DEEPRV_CMD_SEND_FEATURE:  
            dev->is_sending_feature = 1;
            dev->cur_pos = 0;
            break;
        case DEEPRV_CMD_START_COMPUTE:  
            send_start_cmd((int )arg);
            break;
        case DEEPRV_CMD_SEND_BASE_ADDR:  
            send_base_cmd(dev->feature_addr, dev->weight_addr);
            break;
        case DEEPRV_CMD_START_READ:  
            spin_lock(&(dev->lock));
            dev->read_num++;
            spin_unlock(&(dev->lock));
            dev->read_addr = arg;
            break;

        default:  
            return  -1 ;  
    }  
    return 0;  */
}  

static ssize_t deeprv_read(struct file *filp, char __user *buf, size_t size,  
        loff_t *ppos)  
{  
    unsigned long p =  *ppos;  
    unsigned int count = size;  
    int ret = 0;  
    struct deeprv_dev *dev = filp->private_data; 

    //if (p >= GLOBALMEM_SIZE)  
    //    return count ?  - ENXIO: 0;  
    //if (count > GLOBALMEM_SIZE - p)  
    //    count = GLOBALMEM_SIZE - p;  
    for(;;){
        int ok_to_read;
        spin_lock(&(dev->lock));
        ok_to_read = (dev->read_num <= dev->interrupt_num);
        spin_unlock(&(dev->lock));
        if(ok_to_read)
            break;
        msleep(1);
    }
    if (copy_to_user(buf, (void*)(dev->feature_addr + dev->read_addr + p), count))  
    {  
        ret =  - EFAULT;  
    }  
    else  
    {  
        *ppos += count;  
        ret = count;  

        printk(KERN_INFO "read %d bytes(s) from %ld\n", count, p);  
    }  

    return ret;  
}  

static ssize_t deeprv_write(struct file *filp, const char __user *buf,  
        size_t size, loff_t *ppos)  
{  
    unsigned long p =  *ppos;  
    unsigned int count = size;  
    int ret = 0;  
    struct deeprv_dev *dev = filp->private_data; 

    if(dev->is_sending_feature){
        if (p >= dev->feature_size)  
            return count ?  - ENXIO: 0;  
        if (count > dev->feature_size - p)  
            count = dev->feature_size - p;  

        if (copy_from_user(dev->feature_addr + p, buf, count))  
            ret =  - EFAULT;  
        else  
        {  
            *ppos += count;  
            ret = count;  

            printk(KERN_INFO "written %d feature bytes(s) from %ld\n", count, p);  
        }  
    }else{
        if (p >= dev->weight_size)  
            return count ?  - ENXIO: 0;  
        if (count > dev->weight_size - p)  
            count = dev->weight_size - p;  

        if (copy_from_user(dev->weight_addr + p, buf, count))  
            ret =  - EFAULT;  
        else  
        {  
            *ppos += count;  
            ret = count;  

            printk(KERN_INFO "written %d weight bytes(s) from %ld\n", count, p);  
        }  
    }
    return ret;  
}  

static loff_t deeprv_llseek(struct file *filp, loff_t offset, int orig)  
{  
    loff_t ret = 0;  
    struct deeprv_dev *dev = filp->private_data;  
    switch (orig)  
    {  
        case 0:  
            if (offset < 0)  
            {  
                ret =  - EINVAL;  
                break;  
            }  
            if ((unsigned int)offset > MAX_MEM_SIZE)  
            {  
                ret =  - EINVAL;  
                break;  
            }  
            filp->f_pos = (unsigned int)offset;  
            ret = filp->f_pos;  
            if(offset != dev->cur_pos)
                printk(KERN_INFO "should lseek to the start : %lld, pos %d\n", offset, dev->cur_pos);  
            break;  
        case 1: 
            if ((filp->f_pos + offset) > MAX_MEM_SIZE)  
            {  
                ret =  - EINVAL;  
                break;  
            }  
            if ((filp->f_pos + offset) < 0)  
            {  
                ret =  - EINVAL;  
                break;  
            }  
            filp->f_pos += offset;  
            ret = filp->f_pos;  
            break;  
        default:  
            ret =  - EINVAL;  
            break;  
    }  
    return ret;  
}  

static const struct file_operations deeprv_fops =  
{  
    .owner = THIS_MODULE,  
    .llseek = deeprv_llseek,  
    .read = deeprv_read,  
    .write = deeprv_write,  
    .unlocked_ioctl = deeprv_ioctl,  
    .open = deeprv_open,  
    .release = deeprv_release,  
};  

static void deeprv_setup_cdev(struct deeprv_dev *dev, int index)
{
    int err, devno = MKDEV(deeprv_major, index);
    dev->feature_addr = 0;
    dev->weight_addr = 0;
    dev->feature_size = 0;
    dev->weight_size = 0;
    dev->instruction_addr = 0;
    dev->output_addr = 0;
    dev->cur_pos = 0;
    dev->interrupt_num = 0;
    dev->read_num = 0;
    dev->read_addr = 0;
    spin_lock_init(&(dev->lock));

    cdev_init(&dev->cdev, &deeprv_fops);
    dev->cdev.owner = THIS_MODULE;
    err = cdev_add(&dev->cdev, devno, 1);
    if(err)
        printk(KERN_NOTICE "Error %d adding deeprv %d", err, index);
}
static int __init deeprv_init(void) 
{
    int ret;
    dev_t devno = MKDEV(deeprv_major, 0);

    printk(KERN_INFO "init \n");
    send_reset_cmd();
    if(deeprv_major)
        ret = register_chrdev_region(devno, 1, "deeprv");
    else{
        ret = alloc_chrdev_region(&devno, 0, 1, "deeprv");
        if(ret >= 0)
            deeprv_major = MAJOR(devno);
    }
    printk(KERN_INFO "init1 \n");
    if(ret  < 0){
        printk(KERN_NOTICE "region error %d, major %d\n", ret, deeprv_major);
        return ret;
    }
    deeprv_devp = kzalloc(sizeof(struct deeprv_dev), GFP_KERNEL);
    if(!deeprv_devp){
        ret = -ENOMEM;
        goto fail_malloc;
    }
    printk(KERN_INFO "init2 \n");
    deeprv_setup_cdev(deeprv_devp, 0);

    printk(KERN_INFO "rocc irq : %d\n", rocc_irq);
    irq_set_chip_and_handler(rocc_irq, riscv_chip0, deeprv_interrupt_handle);
    irq_set_probe(rocc_irq);
    enable_rocc_interrupt();
    return 0;

fail_malloc:
    unregister_chrdev_region(devno, 1);
    return ret;
}

static void __exit deeprv_exit(void) 
{
    if(deeprv_devp->feature_addr)
        kfree(deeprv_devp->feature_addr);
    if(deeprv_devp->weight_addr)
        kfree(deeprv_devp->weight_addr);
    cdev_del(&deeprv_devp->cdev);
    kfree(deeprv_devp);
    unregister_chrdev_region(MKDEV(deeprv_major, 0), 1);
    printk(KERN_INFO "Goodbye, World!\n");
}

module_init(deeprv_init);
module_exit(deeprv_exit);
