
linuxstart.bin:     file format binary


Disassembly of section .data:

3000 == 77822

00000000 <.data>:
       0:	bc 00 30 01 00       	mov    $0x13000,%esp
       5:	51                   	push   %ecx
       6:	53                   	push   %ebx
       7:	50                   	push   %eax
       8:	e8 f3 2f 00 00       	call   0x3000
       d:	83 c4 0c             	add    $0xc,%esp
      10:	be 00 00 09 00       	mov    $0x90000,%esi
      15:	ea 00 00 10 00 10 00 	ljmp   $0x10,$0x100000
	...
    3000:	55                   	push   %ebp
    3001:	89 e5                	mov    %esp,%ebp
    3003:	56                   	push   %esi
    3004:	53                   	push   %ebx
    3005:	83 ec 20             	sub    $0x20,%esp
    3008:	8b 5d 08             	mov    0x8(%ebp),%ebx
    300b:	8b 75 0c             	mov    0xc(%ebp),%esi
    300e:	c7 04 24 0c 39 01 00 	movl   $0x1390c,(%esp)
    3015:	e8 f6 00 00 00       	call   0x3110
    301a:	c7 44 24 08 80 19 00 	movl   $0x1980,0x8(%esp)
    3021:	00
    3022:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3029:	00
    302a:	c7 04 24 00 00 09 00 	movl   $0x90000,(%esp)
    3031:	e8 7a 02 00 00       	call   0x32b0
    3036:	89 d8                	mov    %ebx,%eax
    3038:	c1 f8 1f             	sar    $0x1f,%eax
    303b:	c1 e8 16             	shr    $0x16,%eax
    303e:	01 d8                	add    %ebx,%eax
    3040:	c1 f8 0a             	sar    $0xa,%eax
    3043:	2d 00 04 00 00       	sub    $0x400,%eax
    3048:	a3 e0 01 09 00       	mov    %eax,0x901e0
    304d:	8b 45 10             	mov    0x10(%ebp),%eax
    3050:	66 c7 05 f2 01 09 00 	movw   $0x0,0x901f2
    3057:	00 00
    3059:	c7 05 28 02 09 00 00 	movl   $0x90800,0x90228
    3060:	08 09 00
    3063:	c7 04 24 00 08 09 00 	movl   $0x90800,(%esp)
    306a:	89 44 24 04          	mov    %eax,0x4(%esp)
    306e:	e8 2d 03 00 00       	call   0x33a0
    3073:	85 f6                	test   %esi,%esi
    3075:	c6 05 10 02 09 00 01 	movb   $0x1,0x90210
    307c:	7e 10                	jle    0x308e
    307e:	c7 05 18 02 09 00 00 	movl   $0x400000,0x90218
    3085:	00 40 00
    3088:	89 35 1c 02 09 00    	mov    %esi,0x9021c
    308e:	c6 05 0e 00 09 00 19 	movb   $0x19,0x9000e
    3095:	8d 45 f2             	lea    -0xe(%ebp),%eax
    3098:	c6 05 07 00 09 00 50 	movb   $0x50,0x90007
    309f:	c7 05 10 10 09 00 ff 	movl   $0xffff,0x91010
    30a6:	ff 00 00
    30a9:	c7 05 14 10 09 00 00 	movl   $0xcf9a00,0x91014
    30b0:	9a cf 00
    30b3:	c7 05 18 10 09 00 ff 	movl   $0xffff,0x91018
    30ba:	ff 00 00
    30bd:	c7 05 1c 10 09 00 00 	movl   $0xcf9200,0x9101c
    30c4:	92 cf 00
    30c7:	66 c7 45 f2 00 08    	movw   $0x800,-0xe(%ebp)
    30cd:	c7 45 f4 00 10 09 00 	movl   $0x91000,-0xc(%ebp)
    30d4:	0f 01 10             	lgdtl  (%eax)
    30d7:	83 c4 20             	add    $0x20,%esp
    30da:	5b                   	pop    %ebx
    30db:	5e                   	pop    %esi
    30dc:	5d                   	pop    %ebp
    30dd:	c3                   	ret
    30de:	90                   	nop
    30df:	90                   	nop
    30e0:	55                   	push   %ebp
    30e1:	89 e5                	mov    %esp,%ebp
    30e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
    30e6:	83 f9 0a             	cmp    $0xa,%ecx
    30e9:	75 0b                	jne    0x30f6
    30eb:	ba f8 03 00 00       	mov    $0x3f8,%edx
    30f0:	b8 0d 00 00 00       	mov    $0xd,%eax
    30f5:	ee                   	out    %al,(%dx)
    30f6:	ba f8 03 00 00       	mov    $0x3f8,%edx
    30fb:	89 c8                	mov    %ecx,%eax
    30fd:	ee                   	out    %al,(%dx)
    30fe:	5d                   	pop    %ebp
    30ff:	c3                   	ret
    3100:	55                   	push   %ebp
    3101:	ba 64 00 00 00       	mov    $0x64,%edx
    3106:	89 e5                	mov    %esp,%ebp
    3108:	b8 fe 00 00 00       	mov    $0xfe,%eax
    310d:	ee                   	out    %al,(%dx)
    310e:	eb fe                	jmp    0x310e
    3110:	55                   	push   %ebp
    3111:	89 e5                	mov    %esp,%ebp
    3113:	57                   	push   %edi
    3114:	8b 7d 08             	mov    0x8(%ebp),%edi
    3117:	56                   	push   %esi
    3118:	53                   	push   %ebx
    3119:	0f b6 07             	movzbl (%edi),%eax
    311c:	84 c0                	test   %al,%al
    311e:	74 30                	je     0x3150
    3120:	bb 0d 00 00 00       	mov    $0xd,%ebx
    3125:	b9 f8 03 00 00       	mov    $0x3f8,%ecx
    312a:	eb 10                	jmp    0x313c
    312c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3130:	89 f0                	mov    %esi,%eax
    3132:	89 ca                	mov    %ecx,%edx
    3134:	ee                   	out    %al,(%dx)
    3135:	0f b6 07             	movzbl (%edi),%eax
    3138:	84 c0                	test   %al,%al
    313a:	74 14                	je     0x3150
    313c:	0f be f0             	movsbl %al,%esi
    313f:	83 c7 01             	add    $0x1,%edi
    3142:	83 fe 0a             	cmp    $0xa,%esi
    3145:	75 e9                	jne    0x3130
    3147:	89 d8                	mov    %ebx,%eax
    3149:	89 ca                	mov    %ecx,%edx
    314b:	ee                   	out    %al,(%dx)
    314c:	eb e2                	jmp    0x3130
    314e:	66 90                	xchg   %ax,%ax
    3150:	5b                   	pop    %ebx
    3151:	5e                   	pop    %esi
    3152:	5f                   	pop    %edi
    3153:	5d                   	pop    %ebp
    3154:	c3                   	ret
    3155:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    3160:	55                   	push   %ebp
    3161:	89 e5                	mov    %esp,%ebp
    3163:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3166:	53                   	push   %ebx
    3167:	89 c8                	mov    %ecx,%eax
    3169:	c1 e8 1c             	shr    $0x1c,%eax
    316c:	0f be 98 b1 39 01 00 	movsbl 0x139b1(%eax),%ebx
    3173:	83 fb 0a             	cmp    $0xa,%ebx
    3176:	0f 84 24 01 00 00    	je     0x32a0
    317c:	ba f8 03 00 00       	mov    $0x3f8,%edx
    3181:	89 d8                	mov    %ebx,%eax
    3183:	ee                   	out    %al,(%dx)
    3184:	89 c8                	mov    %ecx,%eax
    3186:	c1 e8 18             	shr    $0x18,%eax
    3189:	83 e0 0f             	and    $0xf,%eax
    318c:	0f be 98 b1 39 01 00 	movsbl 0x139b1(%eax),%ebx
    3193:	83 fb 0a             	cmp    $0xa,%ebx
    3196:	0f 84 f4 00 00 00    	je     0x3290
    319c:	ba f8 03 00 00       	mov    $0x3f8,%edx
    31a1:	89 d8                	mov    %ebx,%eax
    31a3:	ee                   	out    %al,(%dx)
    31a4:	89 c8                	mov    %ecx,%eax
    31a6:	c1 e8 14             	shr    $0x14,%eax
    31a9:	83 e0 0f             	and    $0xf,%eax
    31ac:	0f be 98 b1 39 01 00 	movsbl 0x139b1(%eax),%ebx
    31b3:	83 fb 0a             	cmp    $0xa,%ebx
    31b6:	0f 84 c4 00 00 00    	je     0x3280
    31bc:	ba f8 03 00 00       	mov    $0x3f8,%edx
    31c1:	89 d8                	mov    %ebx,%eax
    31c3:	ee                   	out    %al,(%dx)
    31c4:	89 c8                	mov    %ecx,%eax
    31c6:	c1 e8 10             	shr    $0x10,%eax
    31c9:	83 e0 0f             	and    $0xf,%eax
    31cc:	0f be 98 b1 39 01 00 	movsbl 0x139b1(%eax),%ebx
    31d3:	83 fb 0a             	cmp    $0xa,%ebx
    31d6:	0f 84 94 00 00 00    	je     0x3270
    31dc:	ba f8 03 00 00       	mov    $0x3f8,%edx
    31e1:	89 d8                	mov    %ebx,%eax
    31e3:	ee                   	out    %al,(%dx)
    31e4:	89 c8                	mov    %ecx,%eax
    31e6:	c1 e8 0c             	shr    $0xc,%eax
    31e9:	83 e0 0f             	and    $0xf,%eax
    31ec:	0f be 98 b1 39 01 00 	movsbl 0x139b1(%eax),%ebx
    31f3:	83 fb 0a             	cmp    $0xa,%ebx
    31f6:	74 70                	je     0x3268
    31f8:	ba f8 03 00 00       	mov    $0x3f8,%edx
    31fd:	89 d8                	mov    %ebx,%eax
    31ff:	ee                   	out    %al,(%dx)
    3200:	89 c8                	mov    %ecx,%eax
    3202:	c1 e8 08             	shr    $0x8,%eax
    3205:	83 e0 0f             	and    $0xf,%eax
    3208:	0f be 98 b1 39 01 00 	movsbl 0x139b1(%eax),%ebx
    320f:	83 fb 0a             	cmp    $0xa,%ebx
    3212:	74 4c                	je     0x3260
    3214:	ba f8 03 00 00       	mov    $0x3f8,%edx
    3219:	89 d8                	mov    %ebx,%eax
    321b:	ee                   	out    %al,(%dx)
    321c:	89 c8                	mov    %ecx,%eax
    321e:	c1 e8 04             	shr    $0x4,%eax
    3221:	83 e0 0f             	and    $0xf,%eax
    3224:	0f be 98 b1 39 01 00 	movsbl 0x139b1(%eax),%ebx
    322b:	83 fb 0a             	cmp    $0xa,%ebx
    322e:	74 28                	je     0x3258
    3230:	ba f8 03 00 00       	mov    $0x3f8,%edx
    3235:	89 d8                	mov    %ebx,%eax
    3237:	ee                   	out    %al,(%dx)
    3238:	83 e1 0f             	and    $0xf,%ecx
    323b:	0f be 89 b1 39 01 00 	movsbl 0x139b1(%ecx),%ecx
    3242:	83 f9 0a             	cmp    $0xa,%ecx
    3245:	75 06                	jne    0x324d
    3247:	b8 0d 00 00 00       	mov    $0xd,%eax
    324c:	ee                   	out    %al,(%dx)
    324d:	ba f8 03 00 00       	mov    $0x3f8,%edx
    3252:	89 c8                	mov    %ecx,%eax
    3254:	ee                   	out    %al,(%dx)
    3255:	5b                   	pop    %ebx
    3256:	5d                   	pop    %ebp
    3257:	c3                   	ret
    3258:	b8 0d 00 00 00       	mov    $0xd,%eax
    325d:	ee                   	out    %al,(%dx)
    325e:	eb d0                	jmp    0x3230
    3260:	b8 0d 00 00 00       	mov    $0xd,%eax
    3265:	ee                   	out    %al,(%dx)
    3266:	eb ac                	jmp    0x3214
    3268:	b8 0d 00 00 00       	mov    $0xd,%eax
    326d:	ee                   	out    %al,(%dx)
    326e:	eb 88                	jmp    0x31f8
    3270:	b8 0d 00 00 00       	mov    $0xd,%eax
    3275:	ee                   	out    %al,(%dx)
    3276:	e9 61 ff ff ff       	jmp    0x31dc
    327b:	90                   	nop
    327c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3280:	b8 0d 00 00 00       	mov    $0xd,%eax
    3285:	ee                   	out    %al,(%dx)
    3286:	e9 31 ff ff ff       	jmp    0x31bc
    328b:	90                   	nop
    328c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3290:	b8 0d 00 00 00       	mov    $0xd,%eax
    3295:	ee                   	out    %al,(%dx)
    3296:	e9 01 ff ff ff       	jmp    0x319c
    329b:	90                   	nop
    329c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    32a0:	ba f8 03 00 00       	mov    $0x3f8,%edx
    32a5:	b8 0d 00 00 00       	mov    $0xd,%eax
    32aa:	ee                   	out    %al,(%dx)
    32ab:	e9 cc fe ff ff       	jmp    0x317c
    32b0:	55                   	push   %ebp
    32b1:	89 e5                	mov    %esp,%ebp
    32b3:	8b 45 10             	mov    0x10(%ebp),%eax
    32b6:	53                   	push   %ebx
    32b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    32ba:	85 c0                	test   %eax,%eax
    32bc:	74 14                	je     0x32d2
    32be:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
    32c2:	31 d2                	xor    %edx,%edx
    32c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    32c8:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
    32cb:	83 c2 01             	add    $0x1,%edx
    32ce:	39 c2                	cmp    %eax,%edx
    32d0:	75 f6                	jne    0x32c8
    32d2:	89 d8                	mov    %ebx,%eax
    32d4:	5b                   	pop    %ebx
    32d5:	5d                   	pop    %ebp
    32d6:	c3                   	ret
    32d7:	89 f6                	mov    %esi,%esi
    32d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    32e0:	55                   	push   %ebp
    32e1:	89 e5                	mov    %esp,%ebp
    32e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
    32e6:	56                   	push   %esi
    32e7:	8b 75 08             	mov    0x8(%ebp),%esi
    32ea:	53                   	push   %ebx
    32eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    32ee:	85 c9                	test   %ecx,%ecx
    32f0:	74 14                	je     0x3306
    32f2:	31 d2                	xor    %edx,%edx
    32f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    32f8:	0f b6 04 13          	movzbl (%ebx,%edx,1),%eax
    32fc:	88 04 16             	mov    %al,(%esi,%edx,1)
    32ff:	83 c2 01             	add    $0x1,%edx
    3302:	39 ca                	cmp    %ecx,%edx
    3304:	75 f2                	jne    0x32f8
    3306:	89 f0                	mov    %esi,%eax
    3308:	5b                   	pop    %ebx
    3309:	5e                   	pop    %esi
    330a:	5d                   	pop    %ebp
    330b:	c3                   	ret
    330c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3310:	55                   	push   %ebp
    3311:	89 e5                	mov    %esp,%ebp
    3313:	57                   	push   %edi
    3314:	56                   	push   %esi
    3315:	53                   	push   %ebx
    3316:	8b 7d 08             	mov    0x8(%ebp),%edi
    3319:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    331c:	8b 75 10             	mov    0x10(%ebp),%esi
    331f:	39 cf                	cmp    %ecx,%edi
    3321:	77 25                	ja     0x3348
    3323:	85 f6                	test   %esi,%esi
    3325:	74 17                	je     0x333e
    3327:	31 d2                	xor    %edx,%edx
    3329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3330:	0f b6 04 11          	movzbl (%ecx,%edx,1),%eax
    3334:	88 04 17             	mov    %al,(%edi,%edx,1)
    3337:	83 c2 01             	add    $0x1,%edx
    333a:	39 d6                	cmp    %edx,%esi
    333c:	75 f2                	jne    0x3330
    333e:	89 f8                	mov    %edi,%eax
    3340:	5b                   	pop    %ebx
    3341:	5e                   	pop    %esi
    3342:	5f                   	pop    %edi
    3343:	5d                   	pop    %ebp
    3344:	c3                   	ret
    3345:	8d 76 00             	lea    0x0(%esi),%esi
    3348:	85 f6                	test   %esi,%esi
    334a:	74 f2                	je     0x333e
    334c:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
    334f:	01 f1                	add    %esi,%ecx
    3351:	31 d2                	xor    %edx,%edx
    3353:	90                   	nop
    3354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3358:	0f b6 44 11 ff       	movzbl -0x1(%ecx,%edx,1),%eax
    335d:	88 44 13 ff          	mov    %al,-0x1(%ebx,%edx,1)
    3361:	83 ea 01             	sub    $0x1,%edx
    3364:	8d 04 32             	lea    (%edx,%esi,1),%eax
    3367:	85 c0                	test   %eax,%eax
    3369:	75 ed                	jne    0x3358
    336b:	89 f8                	mov    %edi,%eax
    336d:	5b                   	pop    %ebx
    336e:	5e                   	pop    %esi
    336f:	5f                   	pop    %edi
    3370:	5d                   	pop    %ebp
    3371:	c3                   	ret
    3372:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    3380:	55                   	push   %ebp
    3381:	31 c0                	xor    %eax,%eax
    3383:	89 e5                	mov    %esp,%ebp
    3385:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3388:	80 39 00             	cmpb   $0x0,(%ecx)
    338b:	89 ca                	mov    %ecx,%edx
    338d:	74 0d                	je     0x339c
    338f:	90                   	nop
    3390:	83 c2 01             	add    $0x1,%edx
    3393:	80 3a 00             	cmpb   $0x0,(%edx)
    3396:	75 f8                	jne    0x3390
    3398:	89 d0                	mov    %edx,%eax
    339a:	29 c8                	sub    %ecx,%eax
    339c:	5d                   	pop    %ebp
    339d:	c3                   	ret
    339e:	66 90                	xchg   %ax,%ax
    33a0:	55                   	push   %ebp
    33a1:	31 c9                	xor    %ecx,%ecx
    33a3:	89 e5                	mov    %esp,%ebp
    33a5:	56                   	push   %esi
    33a6:	8b 75 08             	mov    0x8(%ebp),%esi
    33a9:	53                   	push   %ebx
    33aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    33ad:	80 3b 00             	cmpb   $0x0,(%ebx)
    33b0:	89 d8                	mov    %ebx,%eax
    33b2:	74 15                	je     0x33c9
    33b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    33b8:	83 c0 01             	add    $0x1,%eax
    33bb:	80 38 00             	cmpb   $0x0,(%eax)
    33be:	75 f8                	jne    0x33b8
    33c0:	89 c1                	mov    %eax,%ecx
    33c2:	29 d9                	sub    %ebx,%ecx
    33c4:	83 f9 ff             	cmp    $0xffffffff,%ecx
    33c7:	74 15                	je     0x33de
    33c9:	31 d2                	xor    %edx,%edx
    33cb:	83 c1 01             	add    $0x1,%ecx
    33ce:	66 90                	xchg   %ax,%ax
    33d0:	0f b6 04 13          	movzbl (%ebx,%edx,1),%eax
    33d4:	88 04 16             	mov    %al,(%esi,%edx,1)
    33d7:	83 c2 01             	add    $0x1,%edx
    33da:	39 ca                	cmp    %ecx,%edx
    33dc:	75 f2                	jne    0x33d0
    33de:	89 f0                	mov    %esi,%eax
    33e0:	5b                   	pop    %ebx
    33e1:	5e                   	pop    %esi
    33e2:	5d                   	pop    %ebp
    33e3:	c3                   	ret
    33e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    33ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi
    33f0:	55                   	push   %ebp
    33f1:	89 e5                	mov    %esp,%ebp
    33f3:	57                   	push   %edi
    33f4:	56                   	push   %esi
    33f5:	53                   	push   %ebx
    33f6:	83 ec 40             	sub    $0x40,%esp
    33f9:	8b 45 0c             	mov    0xc(%ebp),%eax
    33fc:	8b 55 08             	mov    0x8(%ebp),%edx
    33ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
    3402:	83 e8 01             	sub    $0x1,%eax
    3405:	85 c0                	test   %eax,%eax
    3407:	89 45 cc             	mov    %eax,-0x34(%ebp)
    340a:	89 55 c8             	mov    %edx,-0x38(%ebp)
    340d:	0f 8e 26 04 00 00    	jle    0x3839
    3413:	8d 75 f3             	lea    -0xd(%ebp),%esi
    3416:	89 75 b4             	mov    %esi,-0x4c(%ebp)
    3419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3420:	8b 7d 10             	mov    0x10(%ebp),%edi
    3423:	0f b6 1f             	movzbl (%edi),%ebx
    3426:	80 fb 25             	cmp    $0x25,%bl
    3429:	74 0d                	je     0x3438
    342b:	84 db                	test   %bl,%bl
    342d:	0f 85 0d 01 00 00    	jne    0x3540
    3433:	90                   	nop
    3434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3438:	3b 4d 10             	cmp    0x10(%ebp),%ecx
    343b:	76 33                	jbe    0x3470
    343d:	89 cb                	mov    %ecx,%ebx
    343f:	2b 5d 10             	sub    0x10(%ebp),%ebx
    3442:	3b 5d cc             	cmp    -0x34(%ebp),%ebx
    3445:	7e 03                	jle    0x344a
    3447:	8b 5d cc             	mov    -0x34(%ebp),%ebx
    344a:	85 db                	test   %ebx,%ebx
    344c:	74 16                	je     0x3464
    344e:	31 d2                	xor    %edx,%edx
    3450:	8b 75 10             	mov    0x10(%ebp),%esi
    3453:	8b 7d c8             	mov    -0x38(%ebp),%edi
    3456:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
    345a:	88 04 17             	mov    %al,(%edi,%edx,1)
    345d:	83 c2 01             	add    $0x1,%edx
    3460:	39 d3                	cmp    %edx,%ebx
    3462:	75 ec                	jne    0x3450
    3464:	01 5d c8             	add    %ebx,-0x38(%ebp)
    3467:	29 5d cc             	sub    %ebx,-0x34(%ebp)
    346a:	0f b6 19             	movzbl (%ecx),%ebx
    346d:	89 4d 10             	mov    %ecx,0x10(%ebp)
    3470:	84 db                	test   %bl,%bl
    3472:	0f 84 ae 00 00 00    	je     0x3526
    3478:	8b 4d 10             	mov    0x10(%ebp),%ecx
    347b:	8b 5d 10             	mov    0x10(%ebp),%ebx
    347e:	0f be 41 01          	movsbl 0x1(%ecx),%eax
    3482:	83 c3 01             	add    $0x1,%ebx
    3485:	c7 45 c0 20 00 00 00 	movl   $0x20,-0x40(%ebp)
    348c:	83 f8 30             	cmp    $0x30,%eax
    348f:	0f 84 db 02 00 00    	je     0x3770
    3495:	83 f8 2a             	cmp    $0x2a,%eax
    3498:	0f 84 ef 02 00 00    	je     0x378d
    349e:	8d 50 d0             	lea    -0x30(%eax),%edx
    34a1:	8b 4d 14             	mov    0x14(%ebp),%ecx
    34a4:	83 fa 09             	cmp    $0x9,%edx
    34a7:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
    34ae:	77 1d                	ja     0x34cd
    34b0:	8b 4d b8             	mov    -0x48(%ebp),%ecx
    34b3:	83 c3 01             	add    $0x1,%ebx
    34b6:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
    34b9:	8d 14 42             	lea    (%edx,%eax,2),%edx
    34bc:	89 55 b8             	mov    %edx,-0x48(%ebp)
    34bf:	0f be 03             	movsbl (%ebx),%eax
    34c2:	8d 50 d0             	lea    -0x30(%eax),%edx
    34c5:	83 fa 09             	cmp    $0x9,%edx
    34c8:	76 e6                	jbe    0x34b0
    34ca:	8b 4d 14             	mov    0x14(%ebp),%ecx
    34cd:	83 f8 2e             	cmp    $0x2e,%eax
    34d0:	0f 84 4a 02 00 00    	je     0x3720
    34d6:	89 4d 14             	mov    %ecx,0x14(%ebp)
    34d9:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    34e0:	31 ff                	xor    %edi,%edi
    34e2:	83 f8 6c             	cmp    $0x6c,%eax
    34e5:	75 0b                	jne    0x34f2
    34e7:	83 c3 01             	add    $0x1,%ebx
    34ea:	bf 01 00 00 00       	mov    $0x1,%edi
    34ef:	0f be 03             	movsbl (%ebx),%eax
    34f2:	8d 70 a8             	lea    -0x58(%eax),%esi
    34f5:	8d 53 01             	lea    0x1(%ebx),%edx
    34f8:	83 fe 20             	cmp    $0x20,%esi
    34fb:	89 55 10             	mov    %edx,0x10(%ebp)
    34fe:	76 60                	jbe    0x3560
    3500:	8b 75 c8             	mov    -0x38(%ebp),%esi
    3503:	83 f8 25             	cmp    $0x25,%eax
    3506:	c6 06 25             	movb   $0x25,(%esi)
    3509:	74 03                	je     0x350e
    350b:	89 5d 10             	mov    %ebx,0x10(%ebp)
    350e:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
    3512:	83 6d cc 01          	subl   $0x1,-0x34(%ebp)
    3516:	66 90                	xchg   %ax,%ax
    3518:	8b 45 cc             	mov    -0x34(%ebp),%eax
    351b:	8b 4d 10             	mov    0x10(%ebp),%ecx
    351e:	85 c0                	test   %eax,%eax
    3520:	0f 8f fa fe ff ff    	jg     0x3420
    3526:	8b 55 c8             	mov    -0x38(%ebp),%edx
    3529:	8b 45 c8             	mov    -0x38(%ebp),%eax
    352c:	2b 45 08             	sub    0x8(%ebp),%eax
    352f:	89 55 08             	mov    %edx,0x8(%ebp)
    3532:	8b 55 08             	mov    0x8(%ebp),%edx
    3535:	c6 02 00             	movb   $0x0,(%edx)
    3538:	83 c4 40             	add    $0x40,%esp
    353b:	5b                   	pop    %ebx
    353c:	5e                   	pop    %esi
    353d:	5f                   	pop    %edi
    353e:	5d                   	pop    %ebp
    353f:	c3                   	ret
    3540:	83 c1 01             	add    $0x1,%ecx
    3543:	0f b6 01             	movzbl (%ecx),%eax
    3546:	3c 25                	cmp    $0x25,%al
    3548:	0f 84 ea fe ff ff    	je     0x3438
    354e:	84 c0                	test   %al,%al
    3550:	75 ee                	jne    0x3540
    3552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    3558:	e9 db fe ff ff       	jmp    0x3438
    355d:	8d 76 00             	lea    0x0(%esi),%esi
    3560:	ff 24 b5 1c 39 01 00 	jmp    *0x1391c(,%esi,4)
    3567:	8b 45 14             	mov    0x14(%ebp),%eax
    356a:	8b 7d 14             	mov    0x14(%ebp),%edi
    356d:	8b 18                	mov    (%eax),%ebx
    356f:	83 c7 04             	add    $0x4,%edi
    3572:	89 7d d0             	mov    %edi,-0x30(%ebp)
    3575:	31 f6                	xor    %esi,%esi
    3577:	89 d8                	mov    %ebx,%eax
    3579:	80 3b 00             	cmpb   $0x0,(%ebx)
    357c:	74 0e                	je     0x358c
    357e:	66 90                	xchg   %ax,%ax
    3580:	83 c0 01             	add    $0x1,%eax
    3583:	80 38 00             	cmpb   $0x0,(%eax)
    3586:	75 f8                	jne    0x3580
    3588:	89 c6                	mov    %eax,%esi
    358a:	29 de                	sub    %ebx,%esi
    358c:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    358f:	85 c9                	test   %ecx,%ecx
    3591:	7e 08                	jle    0x359b
    3593:	39 75 bc             	cmp    %esi,-0x44(%ebp)
    3596:	7d 03                	jge    0x359b
    3598:	8b 75 bc             	mov    -0x44(%ebp),%esi
    359b:	8b 55 b8             	mov    -0x48(%ebp),%edx
    359e:	85 d2                	test   %edx,%edx
    35a0:	7e 33                	jle    0x35d5
    35a2:	8b 45 b8             	mov    -0x48(%ebp),%eax
    35a5:	3b 45 cc             	cmp    -0x34(%ebp),%eax
    35a8:	7e 03                	jle    0x35ad
    35aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
    35ad:	89 c1                	mov    %eax,%ecx
    35af:	29 f1                	sub    %esi,%ecx
    35b1:	85 c9                	test   %ecx,%ecx
    35b3:	7e 20                	jle    0x35d5
    35b5:	0f b6 55 c0          	movzbl -0x40(%ebp),%edx
    35b9:	31 c0                	xor    %eax,%eax
    35bb:	90                   	nop
    35bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    35c0:	8b 7d c8             	mov    -0x38(%ebp),%edi
    35c3:	88 14 07             	mov    %dl,(%edi,%eax,1)
    35c6:	83 c0 01             	add    $0x1,%eax
    35c9:	39 c8                	cmp    %ecx,%eax
    35cb:	75 f3                	jne    0x35c0
    35cd:	29 45 cc             	sub    %eax,-0x34(%ebp)
    35d0:	01 c7                	add    %eax,%edi
    35d2:	89 7d c8             	mov    %edi,-0x38(%ebp)
    35d5:	8b 4d cc             	mov    -0x34(%ebp),%ecx
    35d8:	39 f1                	cmp    %esi,%ecx
    35da:	7e 02                	jle    0x35de
    35dc:	89 f1                	mov    %esi,%ecx
    35de:	85 c9                	test   %ecx,%ecx
    35e0:	74 17                	je     0x35f9
    35e2:	31 d2                	xor    %edx,%edx
    35e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    35e8:	0f b6 04 13          	movzbl (%ebx,%edx,1),%eax
    35ec:	8b 75 c8             	mov    -0x38(%ebp),%esi
    35ef:	88 04 16             	mov    %al,(%esi,%edx,1)
    35f2:	83 c2 01             	add    $0x1,%edx
    35f5:	39 d1                	cmp    %edx,%ecx
    35f7:	75 ef                	jne    0x35e8
    35f9:	8b 7d d0             	mov    -0x30(%ebp),%edi
    35fc:	01 4d c8             	add    %ecx,-0x38(%ebp)
    35ff:	29 4d cc             	sub    %ecx,-0x34(%ebp)
    3602:	89 7d 14             	mov    %edi,0x14(%ebp)
    3605:	e9 0e ff ff ff       	jmp    0x3518
    360a:	8b 4d 14             	mov    0x14(%ebp),%ecx
    360d:	8d 7d d6             	lea    -0x2a(%ebp),%edi
    3610:	8b 75 14             	mov    0x14(%ebp),%esi
    3613:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
    361a:	83 c1 04             	add    $0x4,%ecx
    361d:	8b 06                	mov    (%esi),%eax
    361f:	be 10 00 00 00       	mov    $0x10,%esi
    3624:	89 4d d0             	mov    %ecx,-0x30(%ebp)
    3627:	8d 5d f3             	lea    -0xd(%ebp),%ebx
    362a:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
    362e:	66 90                	xchg   %ax,%ax
    3630:	39 fb                	cmp    %edi,%ebx
    3632:	76 23                	jbe    0x3657
    3634:	31 d2                	xor    %edx,%edx
    3636:	83 eb 01             	sub    $0x1,%ebx
    3639:	f7 f6                	div    %esi
    363b:	89 c1                	mov    %eax,%ecx
    363d:	0f b6 82 a0 39 01 00 	movzbl 0x139a0(%edx),%eax
    3644:	88 03                	mov    %al,(%ebx)
    3646:	89 c8                	mov    %ecx,%eax
    3648:	83 6d bc 01          	subl   $0x1,-0x44(%ebp)
    364c:	8b 55 bc             	mov    -0x44(%ebp),%edx
    364f:	85 d2                	test   %edx,%edx
    3651:	7f dd                	jg     0x3630
    3653:	85 c9                	test   %ecx,%ecx
    3655:	75 d9                	jne    0x3630
    3657:	83 7d c4 01          	cmpl   $0x1,-0x3c(%ebp)
    365b:	0f 84 47 01 00 00    	je     0x37a8
    3661:	83 7d c4 02          	cmpl   $0x2,-0x3c(%ebp)
    3665:	8d 76 00             	lea    0x0(%esi),%esi
    3668:	75 0a                	jne    0x3674
    366a:	c6 43 ff 78          	movb   $0x78,-0x1(%ebx)
    366e:	83 eb 02             	sub    $0x2,%ebx
    3671:	c6 03 30             	movb   $0x30,(%ebx)
    3674:	8b 75 b4             	mov    -0x4c(%ebp),%esi
    3677:	29 de                	sub    %ebx,%esi
    3679:	e9 1d ff ff ff       	jmp    0x359b
    367e:	85 ff                	test   %edi,%edi
    3680:	0f 84 91 01 00 00    	je     0x3817
    3686:	8b 4d 14             	mov    0x14(%ebp),%ecx
    3689:	8d 7d d4             	lea    -0x2c(%ebp),%edi
    368c:	8b 75 14             	mov    0x14(%ebp),%esi
    368f:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    3696:	83 c1 04             	add    $0x4,%ecx
    3699:	8b 06                	mov    (%esi),%eax
    369b:	be 08 00 00 00       	mov    $0x8,%esi
    36a0:	89 4d d0             	mov    %ecx,-0x30(%ebp)
    36a3:	eb 82                	jmp    0x3627
    36a5:	85 ff                	test   %edi,%edi
    36a7:	0f 84 1c 01 00 00    	je     0x37c9
    36ad:	8b 75 14             	mov    0x14(%ebp),%esi
    36b0:	8b 4d 14             	mov    0x14(%ebp),%ecx
    36b3:	8b 06                	mov    (%esi),%eax
    36b5:	83 c1 04             	add    $0x4,%ecx
    36b8:	89 4d d0             	mov    %ecx,-0x30(%ebp)
    36bb:	85 c0                	test   %eax,%eax
    36bd:	0f 88 1c 01 00 00    	js     0x37df
    36c3:	be 0a 00 00 00       	mov    $0xa,%esi
    36c8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    36cf:	8d 7d d4             	lea    -0x2c(%ebp),%edi
    36d2:	e9 50 ff ff ff       	jmp    0x3627
    36d7:	8b 4d 14             	mov    0x14(%ebp),%ecx
    36da:	8d 5d d4             	lea    -0x2c(%ebp),%ebx
    36dd:	8b 55 14             	mov    0x14(%ebp),%edx
    36e0:	8b 01                	mov    (%ecx),%eax
    36e2:	83 c2 04             	add    $0x4,%edx
    36e5:	89 55 d0             	mov    %edx,-0x30(%ebp)
    36e8:	c6 45 d5 00          	movb   $0x0,-0x2b(%ebp)
    36ec:	88 45 d4             	mov    %al,-0x2c(%ebp)
    36ef:	e9 81 fe ff ff       	jmp    0x3575
    36f4:	85 ff                	test   %edi,%edi
    36f6:	0f 84 f9 00 00 00    	je     0x37f5
    36fc:	8b 4d 14             	mov    0x14(%ebp),%ecx
    36ff:	8d 7d d4             	lea    -0x2c(%ebp),%edi
    3702:	8b 75 14             	mov    0x14(%ebp),%esi
    3705:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    370c:	83 c1 04             	add    $0x4,%ecx
    370f:	8b 06                	mov    (%esi),%eax
    3711:	be 10 00 00 00       	mov    $0x10,%esi
    3716:	89 4d d0             	mov    %ecx,-0x30(%ebp)
    3719:	e9 09 ff ff ff       	jmp    0x3627
    371e:	66 90                	xchg   %ax,%ax
    3720:	83 c3 01             	add    $0x1,%ebx
    3723:	0f be 03             	movsbl (%ebx),%eax
    3726:	83 f8 2a             	cmp    $0x2a,%eax
    3729:	0f 84 84 00 00 00    	je     0x37b3
    372f:	8d 50 d0             	lea    -0x30(%eax),%edx
    3732:	83 fa 09             	cmp    $0x9,%edx
    3735:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    373c:	0f 87 94 fd ff ff    	ja     0x34d6
    3742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    3748:	8b 7d bc             	mov    -0x44(%ebp),%edi
    374b:	83 c3 01             	add    $0x1,%ebx
    374e:	8d 04 bf             	lea    (%edi,%edi,4),%eax
    3751:	8d 14 42             	lea    (%edx,%eax,2),%edx
    3754:	89 55 bc             	mov    %edx,-0x44(%ebp)
    3757:	0f be 03             	movsbl (%ebx),%eax
    375a:	8d 50 d0             	lea    -0x30(%eax),%edx
    375d:	83 fa 09             	cmp    $0x9,%edx
    3760:	76 e6                	jbe    0x3748
    3762:	89 4d 14             	mov    %ecx,0x14(%ebp)
    3765:	e9 76 fd ff ff       	jmp    0x34e0
    376a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    3770:	8b 75 10             	mov    0x10(%ebp),%esi
    3773:	8b 5d 10             	mov    0x10(%ebp),%ebx
    3776:	0f be 46 02          	movsbl 0x2(%esi),%eax
    377a:	83 c3 02             	add    $0x2,%ebx
    377d:	c7 45 c0 30 00 00 00 	movl   $0x30,-0x40(%ebp)
    3784:	83 f8 2a             	cmp    $0x2a,%eax
    3787:	0f 85 11 fd ff ff    	jne    0x349e
    378d:	8b 7d 14             	mov    0x14(%ebp),%edi
    3790:	83 c3 01             	add    $0x1,%ebx
    3793:	8b 4d 14             	mov    0x14(%ebp),%ecx
    3796:	8b 3f                	mov    (%edi),%edi
    3798:	83 c1 04             	add    $0x4,%ecx
    379b:	89 7d b8             	mov    %edi,-0x48(%ebp)
    379e:	0f be 03             	movsbl (%ebx),%eax
    37a1:	e9 27 fd ff ff       	jmp    0x34cd
    37a6:	66 90                	xchg   %ax,%ax
    37a8:	83 eb 01             	sub    $0x1,%ebx
    37ab:	c6 03 2d             	movb   $0x2d,(%ebx)
    37ae:	e9 c1 fe ff ff       	jmp    0x3674
    37b3:	8d 71 04             	lea    0x4(%ecx),%esi
    37b6:	8b 09                	mov    (%ecx),%ecx
    37b8:	83 c3 01             	add    $0x1,%ebx
    37bb:	89 75 14             	mov    %esi,0x14(%ebp)
    37be:	89 4d bc             	mov    %ecx,-0x44(%ebp)
    37c1:	0f be 03             	movsbl (%ebx),%eax
    37c4:	e9 17 fd ff ff       	jmp    0x34e0
    37c9:	8b 55 14             	mov    0x14(%ebp),%edx
    37cc:	8b 7d 14             	mov    0x14(%ebp),%edi
    37cf:	8b 02                	mov    (%edx),%eax
    37d1:	83 c7 04             	add    $0x4,%edi
    37d4:	89 7d d0             	mov    %edi,-0x30(%ebp)
    37d7:	85 c0                	test   %eax,%eax
    37d9:	0f 89 e4 fe ff ff    	jns    0x36c3
    37df:	f7 d8                	neg    %eax
    37e1:	be 0a 00 00 00       	mov    $0xa,%esi
    37e6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    37ed:	8d 7d d5             	lea    -0x2b(%ebp),%edi
    37f0:	e9 32 fe ff ff       	jmp    0x3627
    37f5:	8b 7d 14             	mov    0x14(%ebp),%edi
    37f8:	be 10 00 00 00       	mov    $0x10,%esi
    37fd:	8b 55 14             	mov    0x14(%ebp),%edx
    3800:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    3807:	83 c7 04             	add    $0x4,%edi
    380a:	89 7d d0             	mov    %edi,-0x30(%ebp)
    380d:	8b 02                	mov    (%edx),%eax
    380f:	8d 7d d4             	lea    -0x2c(%ebp),%edi
    3812:	e9 10 fe ff ff       	jmp    0x3627
    3817:	8b 7d 14             	mov    0x14(%ebp),%edi
    381a:	be 08 00 00 00       	mov    $0x8,%esi
    381f:	8b 55 14             	mov    0x14(%ebp),%edx
    3822:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    3829:	83 c7 04             	add    $0x4,%edi
    382c:	89 7d d0             	mov    %edi,-0x30(%ebp)
    382f:	8b 02                	mov    (%edx),%eax
    3831:	8d 7d d4             	lea    -0x2c(%ebp),%edi
    3834:	e9 ee fd ff ff       	jmp    0x3627
    3839:	31 c0                	xor    %eax,%eax
    383b:	e9 f2 fc ff ff       	jmp    0x3532
    3840:	8b 0d c4 39 01 00    	mov    0x139c4,%ecx
    3846:	55                   	push   %ebp
    3847:	89 e5                	mov    %esp,%ebp
    3849:	85 c9                	test   %ecx,%ecx
    384b:	74 1b                	je     0x3868
    384d:	a1 c4 39 01 00       	mov    0x139c4,%eax
    3852:	8b 55 08             	mov    0x8(%ebp),%edx
    3855:	5d                   	pop    %ebp
    3856:	8d 54 10 07          	lea    0x7(%eax,%edx,1),%edx
    385a:	83 e2 f8             	and    $0xfffffff8,%edx
    385d:	89 15 c4 39 01 00    	mov    %edx,0x139c4
    3863:	c3                   	ret
    3864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3868:	b8 c9 39 01 00       	mov    $0x139c9,%eax
    386d:	83 e0 f8             	and    $0xfffffff8,%eax
    3870:	a3 c4 39 01 00       	mov    %eax,0x139c4
    3875:	eb d6                	jmp    0x384d
    3877:	89 f6                	mov    %esi,%esi
    3879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    3880:	55                   	push   %ebp
    3881:	89 e5                	mov    %esp,%ebp
    3883:	5d                   	pop    %ebp
    3884:	c3                   	ret
    3885:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    3890:	55                   	push   %ebp
    3891:	89 e5                	mov    %esp,%ebp
    3893:	57                   	push   %edi
    3894:	56                   	push   %esi
    3895:	53                   	push   %ebx
    3896:	81 ec 10 04 00 00    	sub    $0x410,%esp
    389c:	8d 45 0c             	lea    0xc(%ebp),%eax
    389f:	89 44 24 0c          	mov    %eax,0xc(%esp)
    38a3:	8b 45 08             	mov    0x8(%ebp),%eax
    38a6:	8d 9d f4 fb ff ff    	lea    -0x40c(%ebp),%ebx
    38ac:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
    38b3:	00
    38b4:	89 1c 24             	mov    %ebx,(%esp)
    38b7:	89 44 24 08          	mov    %eax,0x8(%esp)
    38bb:	e8 30 fb ff ff       	call   0x33f0
    38c0:	0f b6 85 f4 fb ff ff 	movzbl -0x40c(%ebp),%eax
    38c7:	84 c0                	test   %al,%al
    38c9:	74 35                	je     0x3900
    38cb:	89 df                	mov    %ebx,%edi
    38cd:	b9 f8 03 00 00       	mov    $0x3f8,%ecx
    38d2:	bb 0d 00 00 00       	mov    $0xd,%ebx
    38d7:	eb 13                	jmp    0x38ec
    38d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    38e0:	89 f0                	mov    %esi,%eax
    38e2:	89 ca                	mov    %ecx,%edx
    38e4:	ee                   	out    %al,(%dx)
    38e5:	0f b6 07             	movzbl (%edi),%eax
    38e8:	84 c0                	test   %al,%al
    38ea:	74 14                	je     0x3900
    38ec:	0f be f0             	movsbl %al,%esi
    38ef:	83 c7 01             	add    $0x1,%edi
    38f2:	83 fe 0a             	cmp    $0xa,%esi
    38f5:	75 e9                	jne    0x38e0
    38f7:	89 d8                	mov    %ebx,%eax
    38f9:	89 ca                	mov    %ecx,%edx
    38fb:	ee                   	out    %al,(%dx)
    38fc:	eb e2                	jmp    0x38e0
    38fe:	66 90                	xchg   %ax,%ax
    3900:	81 c4 10 04 00 00    	add    $0x410,%esp
    3906:	5b                   	pop    %ebx
    3907:	5e                   	pop    %esi
    3908:	5f                   	pop    %edi
    3909:	5d                   	pop    %ebp
    390a:	c3                   	ret
    390b:	00 53 74             	add    %dl,0x74(%ebx)
    390e:	61                   	popa
    390f:	72 74                	jb     0x3985
    3911:	69 6e 67 20 4c 69 6e 	imul   $0x6e694c20,0x67(%esi),%ebp
    3918:	75 78                	jne    0x3992
    391a:	0a 00                	or     (%eax),%al
    391c:	f4                   	hlt
    391d:	36 01 00             	add    %eax,%ss:(%eax)
    3920:	00 35 01 00 00 35    	add    %dh,0x35000001
    3926:	01 00                	add    %eax,(%eax)
    3928:	00 35 01 00 00 35    	add    %dh,0x35000001
    392e:	01 00                	add    %eax,(%eax)
    3930:	00 35 01 00 00 35    	add    %dh,0x35000001
    3936:	01 00                	add    %eax,(%eax)
    3938:	00 35 01 00 00 35    	add    %dh,0x35000001
    393e:	01 00                	add    %eax,(%eax)
    3940:	00 35 01 00 00 35    	add    %dh,0x35000001
    3946:	01 00                	add    %eax,(%eax)
    3948:	d7                   	xlat   %ds:(%ebx)
    3949:	36 01 00             	add    %eax,%ss:(%eax)
    394c:	a5                   	movsl  %ds:(%esi),%es:(%edi)
    394d:	36 01 00             	add    %eax,%ss:(%eax)
    3950:	00 35 01 00 00 35    	add    %dh,0x35000001
    3956:	01 00                	add    %eax,(%eax)
    3958:	00 35 01 00 00 35    	add    %dh,0x35000001
    395e:	01 00                	add    %eax,(%eax)
    3960:	00 35 01 00 00 35    	add    %dh,0x35000001
    3966:	01 00                	add    %eax,(%eax)
    3968:	00 35 01 00 00 35    	add    %dh,0x35000001
    396e:	01 00                	add    %eax,(%eax)
    3970:	00 35 01 00 00 35    	add    %dh,0x35000001
    3976:	01 00                	add    %eax,(%eax)
    3978:	7e 36                	jle    0x39b0
    397a:	01 00                	add    %eax,(%eax)
    397c:	0a 36                	or     (%esi),%dh
    397e:	01 00                	add    %eax,(%eax)
    3980:	00 35 01 00 00 35    	add    %dh,0x35000001
    3986:	01 00                	add    %eax,(%eax)
    3988:	67 35 01 00 00 35    	addr16 xor $0x35000001,%eax
    398e:	01 00                	add    %eax,(%eax)
    3990:	00 35 01 00 00 35    	add    %dh,0x35000001
    3996:	01 00                	add    %eax,(%eax)
    3998:	00 35 01 00 f4 36    	add    %dh,0x36f40001
    399e:	01 00                	add    %eax,(%eax)
    39a0:	30 31                	xor    %dh,(%ecx)
    39a2:	32 33                	xor    (%ebx),%dh
    39a4:	34 35                	xor    $0x35,%al
    39a6:	36                   	ss
    39a7:	37                   	aaa
    39a8:	38 39                	cmp    %bh,(%ecx)
    39aa:	61                   	popa
    39ab:	62 63 64             	bound  %esp,0x64(%ebx)
    39ae:	65                   	gs
    39af:	66                   	data16
    39b0:	00 30                	add    %dh,(%eax)
    39b2:	31 32                	xor    %esi,(%edx)
    39b4:	33 34 35 36 37 38 39 	xor    0x39383736(,%esi,1),%esi
    39bb:	61                   	popa
    39bc:	62 63 64             	bound  %esp,0x64(%ebx)
    39bf:	65                   	gs
    39c0:	66                   	data16
	...
