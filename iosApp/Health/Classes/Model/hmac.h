//
//  hmac.h
//  Health
//
//  Created by Alex Volchek on 3/24/15.
//  Copyright (c) 2015 projectvision. All rights reserved.
//

#ifndef HMAC_H
#define HMAC_H 1

extern void hmac_sha1(const u_int8_t *inText, size_t inTextLength, u_int8_t* inKey, const size_t inKeyLength, u_int8_t *outDigest);

#endif /* HMAC_H */