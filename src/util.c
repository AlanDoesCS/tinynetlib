/*
20th August 2025

Utility functions for tinynetlib
 */

#include "util.h"

// RFC 1071 checksum algorithm (https://datatracker.ietf.org/doc/html/rfc1071)
uint16_t tnl_checksum16(const void *data, size_t len);