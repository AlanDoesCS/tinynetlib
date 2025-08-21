#pragma once
#include <stddef.h>
#include <stdint.h>

/* Forward declarations */
struct net_device;

typedef struct net_device_ops {
    int (*send_frame)(struct net_device *dev, const void *data, size_t len);
    size_t (*recv_frame)(struct net_device *dev, void *buffer, size_t len);
} net_device_ops_t;

typedef struct net_device {
    char name[16];         // Device name
    uint8_t mac[6];        // MAC
    uint32_t ip;           // IPv4 (in network byte order)
    uint32_t netmask;      // Subnet mask
    uint32_t gateway;      // Default gateway
    size_t mtu;            // Maximum Transmission Unit
    net_device_ops_t ops;
    void *driver_data;     // Private data for device specific use
} net_device_t;
