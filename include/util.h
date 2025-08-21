#pragma once
#include <stddef.h>
#include <stdint.h>


uint16_t tnl_checksum16(const void *data, size_t len);

static inline uint16_t tnl_ipv4_hdr_checksum(const void *data, size_t len) {
    return tnl_checksum16(data, len);
}
