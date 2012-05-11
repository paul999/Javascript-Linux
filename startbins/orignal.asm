
orignal.bin:     file format binary


Disassembly of section .data:

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
    3000:	56                   	push   %esi
    3001:	53                   	push   %ebx
    3002:	83 ec 24             	sub    $0x24,%esp
    3005:	8b 5c 24 30          	mov    0x30(%esp),%ebx
    3009:	8b 74 24 34          	mov    0x34(%esp),%esi
    300d:	c7 04 24 b4 38 01 00 	movl   $0x138b4,(%esp)
    3014:	e8 07 01 00 00       	call   0x3120
    3019:	c7 44 24 08 80 19 00 	movl   $0x1980,0x8(%esp)
    3020:	00 
    3021:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3028:	00 
    3029:	c7 04 24 00 00 09 00 	movl   $0x90000,(%esp)
    3030:	e8 8b 02 00 00       	call   0x32c0
    3035:	89 d8                	mov    %ebx,%eax
    3037:	c1 f8 1f             	sar    $0x1f,%eax
    303a:	c1 e8 16             	shr    $0x16,%eax
    303d:	01 c3                	add    %eax,%ebx
    303f:	8b 44 24 38          	mov    0x38(%esp),%eax
    3043:	c1 fb 0a             	sar    $0xa,%ebx
    3046:	81 eb 00 04 00 00    	sub    $0x400,%ebx
    304c:	66 c7 05 f2 01 09 00 	movw   $0x0,0x901f2
    3053:	00 00 
    3055:	c7 05 28 02 09 00 00 	movl   $0x90800,0x90228
    305c:	08 09 00 
    305f:	89 1d e0 01 09 00    	mov    %ebx,0x901e0
    3065:	89 44 24 04          	mov    %eax,0x4(%esp)
    3069:	c7 04 24 00 08 09 00 	movl   $0x90800,(%esp)
    3070:	e8 2b 03 00 00       	call   0x33a0
    3075:	85 f6                	test   %esi,%esi
    3077:	c6 05 10 02 09 00 01 	movb   $0x1,0x90210
    307e:	7e 10                	jle    0x3090
    3080:	c7 05 18 02 09 00 00 	movl   $0x500000,0x90218
    3087:	00 50 00 
    308a:	89 35 1c 02 09 00    	mov    %esi,0x9021c
    3090:	c6 05 0e 00 09 00 19 	movb   $0x19,0x9000e
    3097:	8d 44 24 1a          	lea    0x1a(%esp),%eax
    309b:	c6 05 07 00 09 00 50 	movb   $0x50,0x90007
    30a2:	c7 05 10 10 09 00 ff 	movl   $0xffff,0x91010
    30a9:	ff 00 00 
    30ac:	c7 05 14 10 09 00 00 	movl   $0xcf9a00,0x91014
    30b3:	9a cf 00 
    30b6:	c7 05 18 10 09 00 ff 	movl   $0xffff,0x91018
    30bd:	ff 00 00 
    30c0:	c7 05 1c 10 09 00 00 	movl   $0xcf9200,0x9101c
    30c7:	92 cf 00 
    30ca:	66 c7 44 24 1a 00 08 	movw   $0x800,0x1a(%esp)
    30d1:	c7 44 24 1c 00 10 09 	movl   $0x91000,0x1c(%esp)
    30d8:	00 
    30d9:	0f 01 10             	lgdtl  (%eax)
    30dc:	83 c4 24             	add    $0x24,%esp
    30df:	5b                   	pop    %ebx
    30e0:	5e                   	pop    %esi
    30e1:	c3                   	ret    
    30e2:	90                   	nop
    30e3:	90                   	nop
    30e4:	90                   	nop
    30e5:	90                   	nop
    30e6:	90                   	nop
    30e7:	90                   	nop
    30e8:	90                   	nop
    30e9:	90                   	nop
    30ea:	90                   	nop
    30eb:	90                   	nop
    30ec:	90                   	nop
    30ed:	90                   	nop
    30ee:	90                   	nop
    30ef:	90                   	nop
    30f0:	8b 4c 24 04          	mov    0x4(%esp),%ecx
    30f4:	83 f9 0a             	cmp    $0xa,%ecx
    30f7:	75 0b                	jne    0x3104
    30f9:	ba f8 03 00 00       	mov    $0x3f8,%edx
    30fe:	b8 0d 00 00 00       	mov    $0xd,%eax
    3103:	ee                   	out    %al,(%dx)
    3104:	ba f8 03 00 00       	mov    $0x3f8,%edx
    3109:	89 c8                	mov    %ecx,%eax
    310b:	ee                   	out    %al,(%dx)
    310c:	c3                   	ret    
    310d:	8d 76 00             	lea    0x0(%esi),%esi
    3110:	ba 64 00 00 00       	mov    $0x64,%edx
    3115:	b8 fe 00 00 00       	mov    $0xfe,%eax
    311a:	ee                   	out    %al,(%dx)
    311b:	eb fe                	jmp    0x311b
    311d:	8d 76 00             	lea    0x0(%esi),%esi
    3120:	56                   	push   %esi
    3121:	53                   	push   %ebx
    3122:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
    3126:	0f b6 19             	movzbl (%ecx),%ebx
    3129:	84 db                	test   %bl,%bl
    312b:	74 33                	je     0x3160
    312d:	be 0d 00 00 00       	mov    $0xd,%esi
    3132:	ba f8 03 00 00       	mov    $0x3f8,%edx
    3137:	eb 11                	jmp    0x314a
    3139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3140:	89 d8                	mov    %ebx,%eax
    3142:	ee                   	out    %al,(%dx)
    3143:	0f b6 19             	movzbl (%ecx),%ebx
    3146:	84 db                	test   %bl,%bl
    3148:	74 16                	je     0x3160
    314a:	0f be db             	movsbl %bl,%ebx
    314d:	83 c1 01             	add    $0x1,%ecx
    3150:	83 fb 0a             	cmp    $0xa,%ebx
    3153:	75 eb                	jne    0x3140
    3155:	89 f0                	mov    %esi,%eax
    3157:	ee                   	out    %al,(%dx)
    3158:	eb e6                	jmp    0x3140
    315a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    3160:	5b                   	pop    %ebx
    3161:	5e                   	pop    %esi
    3162:	c3                   	ret    
    3163:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    3169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    3170:	53                   	push   %ebx
    3171:	8b 4c 24 08          	mov    0x8(%esp),%ecx
    3175:	89 c8                	mov    %ecx,%eax
    3177:	c1 e8 1c             	shr    $0x1c,%eax
    317a:	0f be 98 48 39 01 00 	movsbl 0x13948(%eax),%ebx
    3181:	83 fb 0a             	cmp    $0xa,%ebx
    3184:	0f 84 26 01 00 00    	je     0x32b0
    318a:	ba f8 03 00 00       	mov    $0x3f8,%edx
    318f:	89 d8                	mov    %ebx,%eax
    3191:	ee                   	out    %al,(%dx)
    3192:	89 c8                	mov    %ecx,%eax
    3194:	c1 e8 18             	shr    $0x18,%eax
    3197:	83 e0 0f             	and    $0xf,%eax
    319a:	0f be 98 48 39 01 00 	movsbl 0x13948(%eax),%ebx
    31a1:	83 fb 0a             	cmp    $0xa,%ebx
    31a4:	0f 84 f6 00 00 00    	je     0x32a0
    31aa:	ba f8 03 00 00       	mov    $0x3f8,%edx
    31af:	89 d8                	mov    %ebx,%eax
    31b1:	ee                   	out    %al,(%dx)
    31b2:	89 c8                	mov    %ecx,%eax
    31b4:	c1 e8 14             	shr    $0x14,%eax
    31b7:	83 e0 0f             	and    $0xf,%eax
    31ba:	0f be 98 48 39 01 00 	movsbl 0x13948(%eax),%ebx
    31c1:	83 fb 0a             	cmp    $0xa,%ebx
    31c4:	0f 84 c6 00 00 00    	je     0x3290
    31ca:	ba f8 03 00 00       	mov    $0x3f8,%edx
    31cf:	89 d8                	mov    %ebx,%eax
    31d1:	ee                   	out    %al,(%dx)
    31d2:	89 c8                	mov    %ecx,%eax
    31d4:	c1 e8 10             	shr    $0x10,%eax
    31d7:	83 e0 0f             	and    $0xf,%eax
    31da:	0f be 98 48 39 01 00 	movsbl 0x13948(%eax),%ebx
    31e1:	83 fb 0a             	cmp    $0xa,%ebx
    31e4:	0f 84 96 00 00 00    	je     0x3280
    31ea:	ba f8 03 00 00       	mov    $0x3f8,%edx
    31ef:	89 d8                	mov    %ebx,%eax
    31f1:	ee                   	out    %al,(%dx)
    31f2:	89 c8                	mov    %ecx,%eax
    31f4:	c1 e8 0c             	shr    $0xc,%eax
    31f7:	83 e0 0f             	and    $0xf,%eax
    31fa:	0f be 98 48 39 01 00 	movsbl 0x13948(%eax),%ebx
    3201:	83 fb 0a             	cmp    $0xa,%ebx
    3204:	74 72                	je     0x3278
    3206:	ba f8 03 00 00       	mov    $0x3f8,%edx
    320b:	89 d8                	mov    %ebx,%eax
    320d:	ee                   	out    %al,(%dx)
    320e:	89 c8                	mov    %ecx,%eax
    3210:	c1 e8 08             	shr    $0x8,%eax
    3213:	83 e0 0f             	and    $0xf,%eax
    3216:	0f be 98 48 39 01 00 	movsbl 0x13948(%eax),%ebx
    321d:	83 fb 0a             	cmp    $0xa,%ebx
    3220:	74 4e                	je     0x3270
    3222:	ba f8 03 00 00       	mov    $0x3f8,%edx
    3227:	89 d8                	mov    %ebx,%eax
    3229:	ee                   	out    %al,(%dx)
    322a:	89 c8                	mov    %ecx,%eax
    322c:	c1 e8 04             	shr    $0x4,%eax
    322f:	83 e0 0f             	and    $0xf,%eax
    3232:	0f be 98 48 39 01 00 	movsbl 0x13948(%eax),%ebx
    3239:	83 fb 0a             	cmp    $0xa,%ebx
    323c:	74 2a                	je     0x3268
    323e:	ba f8 03 00 00       	mov    $0x3f8,%edx
    3243:	89 d8                	mov    %ebx,%eax
    3245:	ee                   	out    %al,(%dx)
    3246:	83 e1 0f             	and    $0xf,%ecx
    3249:	0f be 89 48 39 01 00 	movsbl 0x13948(%ecx),%ecx
    3250:	83 f9 0a             	cmp    $0xa,%ecx
    3253:	75 06                	jne    0x325b
    3255:	b8 0d 00 00 00       	mov    $0xd,%eax
    325a:	ee                   	out    %al,(%dx)
    325b:	ba f8 03 00 00       	mov    $0x3f8,%edx
    3260:	89 c8                	mov    %ecx,%eax
    3262:	ee                   	out    %al,(%dx)
    3263:	5b                   	pop    %ebx
    3264:	c3                   	ret    
    3265:	8d 76 00             	lea    0x0(%esi),%esi
    3268:	b8 0d 00 00 00       	mov    $0xd,%eax
    326d:	ee                   	out    %al,(%dx)
    326e:	eb ce                	jmp    0x323e
    3270:	b8 0d 00 00 00       	mov    $0xd,%eax
    3275:	ee                   	out    %al,(%dx)
    3276:	eb aa                	jmp    0x3222
    3278:	b8 0d 00 00 00       	mov    $0xd,%eax
    327d:	ee                   	out    %al,(%dx)
    327e:	eb 86                	jmp    0x3206
    3280:	b8 0d 00 00 00       	mov    $0xd,%eax
    3285:	ee                   	out    %al,(%dx)
    3286:	e9 5f ff ff ff       	jmp    0x31ea
    328b:	90                   	nop
    328c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3290:	b8 0d 00 00 00       	mov    $0xd,%eax
    3295:	ee                   	out    %al,(%dx)
    3296:	e9 2f ff ff ff       	jmp    0x31ca
    329b:	90                   	nop
    329c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    32a0:	b8 0d 00 00 00       	mov    $0xd,%eax
    32a5:	ee                   	out    %al,(%dx)
    32a6:	e9 ff fe ff ff       	jmp    0x31aa
    32ab:	90                   	nop
    32ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    32b0:	ba f8 03 00 00       	mov    $0x3f8,%edx
    32b5:	b8 0d 00 00 00       	mov    $0xd,%eax
    32ba:	ee                   	out    %al,(%dx)
    32bb:	e9 ca fe ff ff       	jmp    0x318a
    32c0:	53                   	push   %ebx
    32c1:	8b 54 24 10          	mov    0x10(%esp),%edx
    32c5:	8b 44 24 08          	mov    0x8(%esp),%eax
    32c9:	85 d2                	test   %edx,%edx
    32cb:	74 15                	je     0x32e2
    32cd:	0f b6 5c 24 0c       	movzbl 0xc(%esp),%ebx
    32d2:	89 c1                	mov    %eax,%ecx
    32d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    32d8:	88 19                	mov    %bl,(%ecx)
    32da:	83 c1 01             	add    $0x1,%ecx
    32dd:	83 ea 01             	sub    $0x1,%edx
    32e0:	75 f6                	jne    0x32d8
    32e2:	5b                   	pop    %ebx
    32e3:	c3                   	ret    
    32e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    32ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi
    32f0:	56                   	push   %esi
    32f1:	53                   	push   %ebx
    32f2:	8b 5c 24 14          	mov    0x14(%esp),%ebx
    32f6:	8b 44 24 0c          	mov    0xc(%esp),%eax
    32fa:	8b 74 24 10          	mov    0x10(%esp),%esi
    32fe:	85 db                	test   %ebx,%ebx
    3300:	74 14                	je     0x3316
    3302:	31 d2                	xor    %edx,%edx
    3304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3308:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    330c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    330f:	83 c2 01             	add    $0x1,%edx
    3312:	39 da                	cmp    %ebx,%edx
    3314:	75 f2                	jne    0x3308
    3316:	5b                   	pop    %ebx
    3317:	5e                   	pop    %esi
    3318:	c3                   	ret    
    3319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3320:	56                   	push   %esi
    3321:	53                   	push   %ebx
    3322:	8b 44 24 0c          	mov    0xc(%esp),%eax
    3326:	8b 74 24 10          	mov    0x10(%esp),%esi
    332a:	8b 54 24 14          	mov    0x14(%esp),%edx
    332e:	39 f0                	cmp    %esi,%eax
    3330:	77 1e                	ja     0x3350
    3332:	85 d2                	test   %edx,%edx
    3334:	74 10                	je     0x3346
    3336:	31 c9                	xor    %ecx,%ecx
    3338:	0f b6 1c 0e          	movzbl (%esi,%ecx,1),%ebx
    333c:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
    333f:	83 c1 01             	add    $0x1,%ecx
    3342:	39 ca                	cmp    %ecx,%edx
    3344:	75 f2                	jne    0x3338
    3346:	5b                   	pop    %ebx
    3347:	5e                   	pop    %esi
    3348:	c3                   	ret    
    3349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3350:	85 d2                	test   %edx,%edx
    3352:	74 f2                	je     0x3346
    3354:	89 d1                	mov    %edx,%ecx
    3356:	01 d6                	add    %edx,%esi
    3358:	f7 d9                	neg    %ecx
    335a:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
    335d:	01 ce                	add    %ecx,%esi
    335f:	01 cb                	add    %ecx,%ebx
    3361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3368:	0f b6 4c 16 ff       	movzbl -0x1(%esi,%edx,1),%ecx
    336d:	88 4c 13 ff          	mov    %cl,-0x1(%ebx,%edx,1)
    3371:	83 ea 01             	sub    $0x1,%edx
    3374:	75 f2                	jne    0x3368
    3376:	5b                   	pop    %ebx
    3377:	5e                   	pop    %esi
    3378:	c3                   	ret    
    3379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3380:	8b 54 24 04          	mov    0x4(%esp),%edx
    3384:	31 c0                	xor    %eax,%eax
    3386:	80 3a 00             	cmpb   $0x0,(%edx)
    3389:	74 0f                	je     0x339a
    338b:	89 d0                	mov    %edx,%eax
    338d:	8d 76 00             	lea    0x0(%esi),%esi
    3390:	83 c0 01             	add    $0x1,%eax
    3393:	80 38 00             	cmpb   $0x0,(%eax)
    3396:	75 f8                	jne    0x3390
    3398:	29 d0                	sub    %edx,%eax
    339a:	f3 c3                	repz ret 
    339c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    33a0:	56                   	push   %esi
    33a1:	53                   	push   %ebx
    33a2:	8b 5c 24 10          	mov    0x10(%esp),%ebx
    33a6:	8b 44 24 0c          	mov    0xc(%esp),%eax
    33aa:	80 3b 00             	cmpb   $0x0,(%ebx)
    33ad:	74 32                	je     0x33e1
    33af:	89 da                	mov    %ebx,%edx
    33b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    33b8:	83 c2 01             	add    $0x1,%edx
    33bb:	80 3a 00             	cmpb   $0x0,(%edx)
    33be:	75 f8                	jne    0x33b8
    33c0:	89 d1                	mov    %edx,%ecx
    33c2:	29 d9                	sub    %ebx,%ecx
    33c4:	83 f9 ff             	cmp    $0xffffffff,%ecx
    33c7:	74 15                	je     0x33de
    33c9:	31 d2                	xor    %edx,%edx
    33cb:	8d 71 01             	lea    0x1(%ecx),%esi
    33ce:	66 90                	xchg   %ax,%ax
    33d0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
    33d4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    33d7:	83 c2 01             	add    $0x1,%edx
    33da:	39 d6                	cmp    %edx,%esi
    33dc:	75 f2                	jne    0x33d0
    33de:	5b                   	pop    %ebx
    33df:	5e                   	pop    %esi
    33e0:	c3                   	ret    
    33e1:	31 c9                	xor    %ecx,%ecx
    33e3:	eb e4                	jmp    0x33c9
    33e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    33e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    33f0:	55                   	push   %ebp
    33f1:	57                   	push   %edi
    33f2:	56                   	push   %esi
    33f3:	53                   	push   %ebx
    33f4:	83 ec 38             	sub    $0x38,%esp
    33f7:	8b 6c 24 50          	mov    0x50(%esp),%ebp
    33fb:	8d 44 24 37          	lea    0x37(%esp),%eax
    33ff:	89 04 24             	mov    %eax,(%esp)
    3402:	31 c0                	xor    %eax,%eax
    3404:	8b 7c 24 4c          	mov    0x4c(%esp),%edi
    3408:	8b 4c 24 54          	mov    0x54(%esp),%ecx
    340c:	83 ed 01             	sub    $0x1,%ebp
    340f:	85 ed                	test   %ebp,%ebp
    3411:	0f 8e 14 01 00 00    	jle    0x352b
    3417:	0f b6 11             	movzbl (%ecx),%edx
    341a:	84 d2                	test   %dl,%dl
    341c:	0f 84 f9 00 00 00    	je     0x351b
    3422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    3428:	80 fa 25             	cmp    $0x25,%dl
    342b:	89 c8                	mov    %ecx,%eax
    342d:	75 0e                	jne    0x343d
    342f:	e9 e7 00 00 00       	jmp    0x351b
    3434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3438:	80 fb 25             	cmp    $0x25,%bl
    343b:	74 0a                	je     0x3447
    343d:	83 c0 01             	add    $0x1,%eax
    3440:	0f b6 18             	movzbl (%eax),%ebx
    3443:	84 db                	test   %bl,%bl
    3445:	75 f1                	jne    0x3438
    3447:	39 c8                	cmp    %ecx,%eax
    3449:	89 cb                	mov    %ecx,%ebx
    344b:	76 2a                	jbe    0x3477
    344d:	89 c6                	mov    %eax,%esi
    344f:	29 ce                	sub    %ecx,%esi
    3451:	39 ee                	cmp    %ebp,%esi
    3453:	7e 02                	jle    0x3457
    3455:	89 ee                	mov    %ebp,%esi
    3457:	85 f6                	test   %esi,%esi
    3459:	74 13                	je     0x346e
    345b:	31 d2                	xor    %edx,%edx
    345d:	8d 76 00             	lea    0x0(%esi),%esi
    3460:	0f b6 1c 11          	movzbl (%ecx,%edx,1),%ebx
    3464:	88 1c 17             	mov    %bl,(%edi,%edx,1)
    3467:	83 c2 01             	add    $0x1,%edx
    346a:	39 d6                	cmp    %edx,%esi
    346c:	75 f2                	jne    0x3460
    346e:	0f b6 10             	movzbl (%eax),%edx
    3471:	01 f7                	add    %esi,%edi
    3473:	29 f5                	sub    %esi,%ebp
    3475:	89 c3                	mov    %eax,%ebx
    3477:	84 d2                	test   %dl,%dl
    3479:	0f 84 a6 00 00 00    	je     0x3525
    347f:	0f be 43 01          	movsbl 0x1(%ebx),%eax
    3483:	83 f8 30             	cmp    $0x30,%eax
    3486:	0f 84 04 03 00 00    	je     0x3790
    348c:	8d 53 01             	lea    0x1(%ebx),%edx
    348f:	c7 44 24 10 20 00 00 	movl   $0x20,0x10(%esp)
    3496:	00 
    3497:	83 f8 2a             	cmp    $0x2a,%eax
    349a:	0f 84 d0 02 00 00    	je     0x3770
    34a0:	8d 48 d0             	lea    -0x30(%eax),%ecx
    34a3:	31 f6                	xor    %esi,%esi
    34a5:	83 f9 09             	cmp    $0x9,%ecx
    34a8:	77 1b                	ja     0x34c5
    34aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    34b0:	8d 0c b6             	lea    (%esi,%esi,4),%ecx
    34b3:	83 c2 01             	add    $0x1,%edx
    34b6:	8d 74 48 d0          	lea    -0x30(%eax,%ecx,2),%esi
    34ba:	0f be 02             	movsbl (%edx),%eax
    34bd:	8d 48 d0             	lea    -0x30(%eax),%ecx
    34c0:	83 f9 09             	cmp    $0x9,%ecx
    34c3:	76 eb                	jbe    0x34b0
    34c5:	31 db                	xor    %ebx,%ebx
    34c7:	83 f8 2e             	cmp    $0x2e,%eax
    34ca:	0f 84 68 02 00 00    	je     0x3738
    34d0:	83 f8 6c             	cmp    $0x6c,%eax
    34d3:	74 63                	je     0x3538
    34d5:	8d 4a 01             	lea    0x1(%edx),%ecx
    34d8:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    34dc:	8d 48 a8             	lea    -0x58(%eax),%ecx
    34df:	83 f9 20             	cmp    $0x20,%ecx
    34e2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    34e9:	00 
    34ea:	76 6a                	jbe    0x3556
    34ec:	c6 07 25             	movb   $0x25,(%edi)
    34ef:	83 c7 01             	add    $0x1,%edi
    34f2:	83 f8 25             	cmp    $0x25,%eax
    34f5:	0f 84 d2 02 00 00    	je     0x37cd
    34fb:	83 ed 01             	sub    $0x1,%ebp
    34fe:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    3508:	85 ed                	test   %ebp,%ebp
    350a:	7e 19                	jle    0x3525
    350c:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
    3510:	0f b6 11             	movzbl (%ecx),%edx
    3513:	84 d2                	test   %dl,%dl
    3515:	0f 85 0d ff ff ff    	jne    0x3428
    351b:	84 d2                	test   %dl,%dl
    351d:	89 cb                	mov    %ecx,%ebx
    351f:	0f 85 5a ff ff ff    	jne    0x347f
    3525:	89 f8                	mov    %edi,%eax
    3527:	2b 44 24 4c          	sub    0x4c(%esp),%eax
    352b:	c6 07 00             	movb   $0x0,(%edi)
    352e:	83 c4 38             	add    $0x38,%esp
    3531:	5b                   	pop    %ebx
    3532:	5e                   	pop    %esi
    3533:	5f                   	pop    %edi
    3534:	5d                   	pop    %ebp
    3535:	c3                   	ret    
    3536:	66 90                	xchg   %ax,%ax
    3538:	0f be 42 01          	movsbl 0x1(%edx),%eax
    353c:	83 c2 01             	add    $0x1,%edx
    353f:	8d 4a 01             	lea    0x1(%edx),%ecx
    3542:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    3546:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    354d:	00 
    354e:	8d 48 a8             	lea    -0x58(%eax),%ecx
    3551:	83 f9 20             	cmp    $0x20,%ecx
    3554:	77 96                	ja     0x34ec
    3556:	ff 24 8d c4 38 01 00 	jmp    *0x138c4(,%ecx,4)
    355d:	8b 44 24 58          	mov    0x58(%esp),%eax
    3561:	8b 08                	mov    (%eax),%ecx
    3563:	83 c0 04             	add    $0x4,%eax
    3566:	89 44 24 58          	mov    %eax,0x58(%esp)
    356a:	0f b6 11             	movzbl (%ecx),%edx
    356d:	89 c8                	mov    %ecx,%eax
    356f:	84 d2                	test   %dl,%dl
    3571:	0f 84 89 01 00 00    	je     0x3700
    3577:	90                   	nop
    3578:	83 c0 01             	add    $0x1,%eax
    357b:	80 38 00             	cmpb   $0x0,(%eax)
    357e:	75 f8                	jne    0x3578
    3580:	29 c8                	sub    %ecx,%eax
    3582:	89 44 24 04          	mov    %eax,0x4(%esp)
    3586:	3b 5c 24 04          	cmp    0x4(%esp),%ebx
    358a:	7d 08                	jge    0x3594
    358c:	85 db                	test   %ebx,%ebx
    358e:	7e 04                	jle    0x3594
    3590:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    3594:	85 f6                	test   %esi,%esi
    3596:	7e 2c                	jle    0x35c4
    3598:	39 ee                	cmp    %ebp,%esi
    359a:	7e 02                	jle    0x359e
    359c:	89 ee                	mov    %ebp,%esi
    359e:	2b 74 24 04          	sub    0x4(%esp),%esi
    35a2:	85 f6                	test   %esi,%esi
    35a4:	7e 1e                	jle    0x35c4
    35a6:	0f b6 5c 24 10       	movzbl 0x10(%esp),%ebx
    35ab:	29 f5                	sub    %esi,%ebp
    35ad:	89 f2                	mov    %esi,%edx
    35af:	89 f8                	mov    %edi,%eax
    35b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    35b8:	88 18                	mov    %bl,(%eax)
    35ba:	83 c0 01             	add    $0x1,%eax
    35bd:	83 ea 01             	sub    $0x1,%edx
    35c0:	75 f6                	jne    0x35b8
    35c2:	01 f7                	add    %esi,%edi
    35c4:	3b 6c 24 04          	cmp    0x4(%esp),%ebp
    35c8:	89 ea                	mov    %ebp,%edx
    35ca:	7e 04                	jle    0x35d0
    35cc:	8b 54 24 04          	mov    0x4(%esp),%edx
    35d0:	85 d2                	test   %edx,%edx
    35d2:	74 12                	je     0x35e6
    35d4:	31 c0                	xor    %eax,%eax
    35d6:	66 90                	xchg   %ax,%ax
    35d8:	0f b6 1c 01          	movzbl (%ecx,%eax,1),%ebx
    35dc:	88 1c 07             	mov    %bl,(%edi,%eax,1)
    35df:	83 c0 01             	add    $0x1,%eax
    35e2:	39 d0                	cmp    %edx,%eax
    35e4:	75 f2                	jne    0x35d8
    35e6:	01 d7                	add    %edx,%edi
    35e8:	29 d5                	sub    %edx,%ebp
    35ea:	e9 19 ff ff ff       	jmp    0x3508
    35ef:	8b 4c 24 58          	mov    0x58(%esp),%ecx
    35f3:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    35fa:	00 
    35fb:	c7 44 24 14 02 00 00 	movl   $0x2,0x14(%esp)
    3602:	00 
    3603:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
    360a:	00 
    360b:	8b 01                	mov    (%ecx),%eax
    360d:	83 c1 04             	add    $0x4,%ecx
    3610:	89 4c 24 58          	mov    %ecx,0x58(%esp)
    3614:	8d 54 24 18          	lea    0x18(%esp),%edx
    3618:	03 54 24 08          	add    0x8(%esp),%edx
    361c:	c6 44 24 37 00       	movb   $0x0,0x37(%esp)
    3621:	8d 4c 24 37          	lea    0x37(%esp),%ecx
    3625:	89 54 24 08          	mov    %edx,0x8(%esp)
    3629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3630:	3b 4c 24 08          	cmp    0x8(%esp),%ecx
    3634:	76 1d                	jbe    0x3653
    3636:	31 d2                	xor    %edx,%edx
    3638:	83 eb 01             	sub    $0x1,%ebx
    363b:	f7 74 24 04          	divl   0x4(%esp)
    363f:	83 e9 01             	sub    $0x1,%ecx
    3642:	85 db                	test   %ebx,%ebx
    3644:	0f b6 92 59 39 01 00 	movzbl 0x13959(%edx),%edx
    364b:	88 11                	mov    %dl,(%ecx)
    364d:	7f e1                	jg     0x3630
    364f:	85 c0                	test   %eax,%eax
    3651:	75 dd                	jne    0x3630
    3653:	83 7c 24 14 01       	cmpl   $0x1,0x14(%esp)
    3658:	0f 84 4a 01 00 00    	je     0x37a8
    365e:	83 7c 24 14 02       	cmpl   $0x2,0x14(%esp)
    3663:	75 0b                	jne    0x3670
    3665:	c6 41 ff 78          	movb   $0x78,-0x1(%ecx)
    3669:	c6 41 fe 30          	movb   $0x30,-0x2(%ecx)
    366d:	83 e9 02             	sub    $0x2,%ecx
    3670:	8b 04 24             	mov    (%esp),%eax
    3673:	29 c8                	sub    %ecx,%eax
    3675:	89 44 24 04          	mov    %eax,0x4(%esp)
    3679:	e9 16 ff ff ff       	jmp    0x3594
    367e:	8b 4c 24 58          	mov    0x58(%esp),%ecx
    3682:	8b 01                	mov    (%ecx),%eax
    3684:	83 c1 04             	add    $0x4,%ecx
    3687:	89 4c 24 58          	mov    %ecx,0x58(%esp)
    368b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    3692:	00 
    3693:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
    369a:	00 
    369b:	c7 44 24 04 08 00 00 	movl   $0x8,0x4(%esp)
    36a2:	00 
    36a3:	e9 6c ff ff ff       	jmp    0x3614
    36a8:	8b 4c 24 58          	mov    0x58(%esp),%ecx
    36ac:	8b 01                	mov    (%ecx),%eax
    36ae:	83 c1 04             	add    $0x4,%ecx
    36b1:	89 4c 24 58          	mov    %ecx,0x58(%esp)
    36b5:	85 c0                	test   %eax,%eax
    36b7:	0f 88 19 01 00 00    	js     0x37d6
    36bd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    36c4:	00 
    36c5:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
    36cc:	00 
    36cd:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
    36d4:	00 
    36d5:	e9 3a ff ff ff       	jmp    0x3614
    36da:	8b 4c 24 58          	mov    0x58(%esp),%ecx
    36de:	c6 44 24 19 00       	movb   $0x0,0x19(%esp)
    36e3:	8b 01                	mov    (%ecx),%eax
    36e5:	83 c1 04             	add    $0x4,%ecx
    36e8:	89 4c 24 58          	mov    %ecx,0x58(%esp)
    36ec:	8d 4c 24 18          	lea    0x18(%esp),%ecx
    36f0:	89 c2                	mov    %eax,%edx
    36f2:	84 d2                	test   %dl,%dl
    36f4:	88 44 24 18          	mov    %al,0x18(%esp)
    36f8:	89 c8                	mov    %ecx,%eax
    36fa:	0f 85 78 fe ff ff    	jne    0x3578
    3700:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3707:	00 
    3708:	e9 79 fe ff ff       	jmp    0x3586
    370d:	8b 4c 24 58          	mov    0x58(%esp),%ecx
    3711:	8b 01                	mov    (%ecx),%eax
    3713:	83 c1 04             	add    $0x4,%ecx
    3716:	89 4c 24 58          	mov    %ecx,0x58(%esp)
    371a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    3721:	00 
    3722:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
    3729:	00 
    372a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
    3731:	00 
    3732:	e9 dd fe ff ff       	jmp    0x3614
    3737:	90                   	nop
    3738:	0f be 42 01          	movsbl 0x1(%edx),%eax
    373c:	83 f8 2a             	cmp    $0x2a,%eax
    373f:	74 73                	je     0x37b4
    3741:	8d 48 d0             	lea    -0x30(%eax),%ecx
    3744:	83 c2 01             	add    $0x1,%edx
    3747:	83 f9 09             	cmp    $0x9,%ecx
    374a:	0f 87 80 fd ff ff    	ja     0x34d0
    3750:	8d 0c 9b             	lea    (%ebx,%ebx,4),%ecx
    3753:	83 c2 01             	add    $0x1,%edx
    3756:	8d 5c 48 d0          	lea    -0x30(%eax,%ecx,2),%ebx
    375a:	0f be 02             	movsbl (%edx),%eax
    375d:	8d 48 d0             	lea    -0x30(%eax),%ecx
    3760:	83 f9 09             	cmp    $0x9,%ecx
    3763:	76 eb                	jbe    0x3750
    3765:	e9 66 fd ff ff       	jmp    0x34d0
    376a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    3770:	8b 4c 24 58          	mov    0x58(%esp),%ecx
    3774:	0f be 42 01          	movsbl 0x1(%edx),%eax
    3778:	83 c2 01             	add    $0x1,%edx
    377b:	8b 31                	mov    (%ecx),%esi
    377d:	83 c1 04             	add    $0x4,%ecx
    3780:	89 4c 24 58          	mov    %ecx,0x58(%esp)
    3784:	e9 3c fd ff ff       	jmp    0x34c5
    3789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3790:	8d 53 02             	lea    0x2(%ebx),%edx
    3793:	0f be 43 02          	movsbl 0x2(%ebx),%eax
    3797:	c7 44 24 10 30 00 00 	movl   $0x30,0x10(%esp)
    379e:	00 
    379f:	e9 f3 fc ff ff       	jmp    0x3497
    37a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    37a8:	c6 41 ff 2d          	movb   $0x2d,-0x1(%ecx)
    37ac:	83 e9 01             	sub    $0x1,%ecx
    37af:	e9 bc fe ff ff       	jmp    0x3670
    37b4:	8b 4c 24 58          	mov    0x58(%esp),%ecx
    37b8:	0f be 42 02          	movsbl 0x2(%edx),%eax
    37bc:	83 c2 02             	add    $0x2,%edx
    37bf:	8b 19                	mov    (%ecx),%ebx
    37c1:	83 c1 04             	add    $0x4,%ecx
    37c4:	89 4c 24 58          	mov    %ecx,0x58(%esp)
    37c8:	e9 03 fd ff ff       	jmp    0x34d0
    37cd:	8b 54 24 0c          	mov    0xc(%esp),%edx
    37d1:	e9 25 fd ff ff       	jmp    0x34fb
    37d6:	f7 d8                	neg    %eax
    37d8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    37df:	00 
    37e0:	c7 44 24 14 01 00 00 	movl   $0x1,0x14(%esp)
    37e7:	00 
    37e8:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
    37ef:	00 
    37f0:	e9 1f fe ff ff       	jmp    0x3614
    37f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    37f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    3800:	56                   	push   %esi
    3801:	53                   	push   %ebx
    3802:	81 ec 10 04 00 00    	sub    $0x410,%esp
    3808:	8d 84 24 20 04 00 00 	lea    0x420(%esp),%eax
    380f:	89 44 24 0c          	mov    %eax,0xc(%esp)
    3813:	8b 84 24 1c 04 00 00 	mov    0x41c(%esp),%eax
    381a:	8d 74 24 10          	lea    0x10(%esp),%esi
    381e:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
    3825:	00 
    3826:	89 34 24             	mov    %esi,(%esp)
    3829:	89 44 24 08          	mov    %eax,0x8(%esp)
    382d:	e8 be fb ff ff       	call   0x33f0
    3832:	0f b6 5c 24 10       	movzbl 0x10(%esp),%ebx
    3837:	84 db                	test   %bl,%bl
    3839:	74 35                	je     0x3870
    383b:	89 f1                	mov    %esi,%ecx
    383d:	ba f8 03 00 00       	mov    $0x3f8,%edx
    3842:	be 0d 00 00 00       	mov    $0xd,%esi
    3847:	eb 11                	jmp    0x385a
    3849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3850:	89 d8                	mov    %ebx,%eax
    3852:	ee                   	out    %al,(%dx)
    3853:	0f b6 19             	movzbl (%ecx),%ebx
    3856:	84 db                	test   %bl,%bl
    3858:	74 16                	je     0x3870
    385a:	0f be db             	movsbl %bl,%ebx
    385d:	83 c1 01             	add    $0x1,%ecx
    3860:	83 fb 0a             	cmp    $0xa,%ebx
    3863:	75 eb                	jne    0x3850
    3865:	89 f0                	mov    %esi,%eax
    3867:	ee                   	out    %al,(%dx)
    3868:	eb e6                	jmp    0x3850
    386a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    3870:	81 c4 10 04 00 00    	add    $0x410,%esp
    3876:	5b                   	pop    %ebx
    3877:	5e                   	pop    %esi
    3878:	c3                   	ret    
    3879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3880:	a1 5c 3b 01 00       	mov    0x13b5c,%eax
    3885:	85 c0                	test   %eax,%eax
    3887:	74 17                	je     0x38a0
    3889:	8b 54 24 04          	mov    0x4(%esp),%edx
    388d:	8d 54 10 07          	lea    0x7(%eax,%edx,1),%edx
    3891:	83 e2 f8             	and    $0xfffffff8,%edx
    3894:	89 15 5c 3b 01 00    	mov    %edx,0x13b5c
    389a:	c3                   	ret    
    389b:	90                   	nop
    389c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    38a0:	b8 63 3b 01 00       	mov    $0x13b63,%eax
    38a5:	83 e0 f8             	and    $0xfffffff8,%eax
    38a8:	eb df                	jmp    0x3889
    38aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    38b0:	f3 c3                	repz ret 
    38b2:	00 00                	add    %al,(%eax)
    38b4:	53                   	push   %ebx
    38b5:	74 61                	je     0x3918
    38b7:	72 74                	jb     0x392d
    38b9:	69 6e 67 20 4c 69 6e 	imul   $0x6e694c20,0x67(%esi),%ebp
    38c0:	75 78                	jne    0x393a
    38c2:	0a 00                	or     (%eax),%al
    38c4:	0d 37 01 00 ec       	or     $0xec000137,%eax
    38c9:	34 01                	xor    $0x1,%al
    38cb:	00 ec                	add    %ch,%ah
    38cd:	34 01                	xor    $0x1,%al
    38cf:	00 ec                	add    %ch,%ah
    38d1:	34 01                	xor    $0x1,%al
    38d3:	00 ec                	add    %ch,%ah
    38d5:	34 01                	xor    $0x1,%al
    38d7:	00 ec                	add    %ch,%ah
    38d9:	34 01                	xor    $0x1,%al
    38db:	00 ec                	add    %ch,%ah
    38dd:	34 01                	xor    $0x1,%al
    38df:	00 ec                	add    %ch,%ah
    38e1:	34 01                	xor    $0x1,%al
    38e3:	00 ec                	add    %ch,%ah
    38e5:	34 01                	xor    $0x1,%al
    38e7:	00 ec                	add    %ch,%ah
    38e9:	34 01                	xor    $0x1,%al
    38eb:	00 ec                	add    %ch,%ah
    38ed:	34 01                	xor    $0x1,%al
    38ef:	00 da                	add    %bl,%dl
    38f1:	36 01 00             	add    %eax,%ss:(%eax)
    38f4:	a8 36                	test   $0x36,%al
    38f6:	01 00                	add    %eax,(%eax)
    38f8:	ec                   	in     (%dx),%al
    38f9:	34 01                	xor    $0x1,%al
    38fb:	00 ec                	add    %ch,%ah
    38fd:	34 01                	xor    $0x1,%al
    38ff:	00 ec                	add    %ch,%ah
    3901:	34 01                	xor    $0x1,%al
    3903:	00 ec                	add    %ch,%ah
    3905:	34 01                	xor    $0x1,%al
    3907:	00 ec                	add    %ch,%ah
    3909:	34 01                	xor    $0x1,%al
    390b:	00 ec                	add    %ch,%ah
    390d:	34 01                	xor    $0x1,%al
    390f:	00 ec                	add    %ch,%ah
    3911:	34 01                	xor    $0x1,%al
    3913:	00 ec                	add    %ch,%ah
    3915:	34 01                	xor    $0x1,%al
    3917:	00 ec                	add    %ch,%ah
    3919:	34 01                	xor    $0x1,%al
    391b:	00 ec                	add    %ch,%ah
    391d:	34 01                	xor    $0x1,%al
    391f:	00 7e 36             	add    %bh,0x36(%esi)
    3922:	01 00                	add    %eax,(%eax)
    3924:	ef                   	out    %eax,(%dx)
    3925:	35 01 00 ec 34       	xor    $0x34ec0001,%eax
    392a:	01 00                	add    %eax,(%eax)
    392c:	ec                   	in     (%dx),%al
    392d:	34 01                	xor    $0x1,%al
    392f:	00 5d 35             	add    %bl,0x35(%ebp)
    3932:	01 00                	add    %eax,(%eax)
    3934:	ec                   	in     (%dx),%al
    3935:	34 01                	xor    $0x1,%al
    3937:	00 ec                	add    %ch,%ah
    3939:	34 01                	xor    $0x1,%al
    393b:	00 ec                	add    %ch,%ah
    393d:	34 01                	xor    $0x1,%al
    393f:	00 ec                	add    %ch,%ah
    3941:	34 01                	xor    $0x1,%al
    3943:	00 0d 37 01 00 30    	add    %cl,0x30000137
    3949:	31 32                	xor    %esi,(%edx)
    394b:	33 34 35 36 37 38 39 	xor    0x39383736(,%esi,1),%esi
    3952:	61                   	popa   
    3953:	62 63 64             	bound  %esp,0x64(%ebx)
    3956:	65                   	gs
    3957:	66                   	data16
    3958:	00 30                	add    %dh,(%eax)
    395a:	31 32                	xor    %esi,(%edx)
    395c:	33 34 35 36 37 38 39 	xor    0x39383736(,%esi,1),%esi
    3963:	61                   	popa   
    3964:	62 63 64             	bound  %esp,0x64(%ebx)
    3967:	65                   	gs
    3968:	66                   	data16
    3969:	00 00                	add    %al,(%eax)
    396b:	00 14 00             	add    %dl,(%eax,%eax,1)
    396e:	00 00                	add    %al,(%eax)
    3970:	00 00                	add    %al,(%eax)
    3972:	00 00                	add    %al,(%eax)
    3974:	01 7a 52             	add    %edi,0x52(%edx)
    3977:	00 01                	add    %al,(%ecx)
    3979:	7c 08                	jl     0x3983
    397b:	01 1b                	add    %ebx,(%ebx)
    397d:	0c 04                	or     $0x4,%al
    397f:	04 88                	add    $0x88,%al
    3981:	01 00                	add    %eax,(%eax)
    3983:	00 28                	add    %ch,(%eax)
    3985:	00 00                	add    %al,(%eax)
    3987:	00 1c 00             	add    %bl,(%eax,%eax,1)
    398a:	00 00                	add    %al,(%eax)
    398c:	74 f6                	je     0x3984
    398e:	ff                   	(bad)  
    398f:	ff e2                	jmp    *%edx
    3991:	00 00                	add    %al,(%eax)
    3993:	00 00                	add    %al,(%eax)
    3995:	41                   	inc    %ecx
    3996:	0e                   	push   %cs
    3997:	08 86 02 41 0e 0c    	or     %al,0xc0e4102(%esi)
    399d:	83 03 43             	addl   $0x43,(%ebx)
    39a0:	0e                   	push   %cs
    39a1:	30 02                	xor    %al,(%edx)
    39a3:	da 0e                	fimull (%esi)
    39a5:	0c 41                	or     $0x41,%al
    39a7:	0e                   	push   %cs
    39a8:	08 c3                	or     %al,%bl
    39aa:	41                   	inc    %ecx
    39ab:	0e                   	push   %cs
    39ac:	04 c6                	add    $0xc6,%al
    39ae:	00 00                	add    %al,(%eax)
    39b0:	10 00                	adc    %al,(%eax)
    39b2:	00 00                	add    %al,(%eax)
    39b4:	48                   	dec    %eax
    39b5:	00 00                	add    %al,(%eax)
    39b7:	00 38                	add    %bh,(%eax)
    39b9:	f7 ff                	idiv   %edi
    39bb:	ff 1d 00 00 00 00    	lcall  *0x0
    39c1:	00 00                	add    %al,(%eax)
    39c3:	00 10                	add    %dl,(%eax)
    39c5:	00 00                	add    %al,(%eax)
    39c7:	00 5c 00 00          	add    %bl,0x0(%eax,%eax,1)
    39cb:	00 44 f7 ff          	add    %al,-0x1(%edi,%esi,8)
    39cf:	ff 0d 00 00 00 00    	decl   0x0
    39d5:	00 00                	add    %al,(%eax)
    39d7:	00 20                	add    %ah,(%eax)
    39d9:	00 00                	add    %al,(%eax)
    39db:	00 70 00             	add    %dh,0x0(%eax)
    39de:	00 00                	add    %al,(%eax)
    39e0:	40                   	inc    %eax
    39e1:	f7 ff                	idiv   %edi
    39e3:	ff 43 00             	incl   0x0(%ebx)
    39e6:	00 00                	add    %al,(%eax)
    39e8:	00 41 0e             	add    %al,0xe(%ecx)
    39eb:	08 86 02 41 0e 0c    	or     %al,0xc0e4102(%esi)
    39f1:	83 03 7f             	addl   $0x7f,(%ebx)
    39f4:	0e                   	push   %cs
    39f5:	08 c3                	or     %al,%bl
    39f7:	41                   	inc    %ecx
    39f8:	0e                   	push   %cs
    39f9:	04 c6                	add    $0xc6,%al
    39fb:	00 1c 00             	add    %bl,(%eax,%eax,1)
    39fe:	00 00                	add    %al,(%eax)
    3a00:	94                   	xchg   %eax,%esp
    3a01:	00 00                	add    %al,(%eax)
    3a03:	00 6c f7 ff          	add    %ch,-0x1(%edi,%esi,8)
    3a07:	ff 50 01             	call   *0x1(%eax)
    3a0a:	00 00                	add    %al,(%eax)
    3a0c:	00 41 0e             	add    %al,0xe(%ecx)
    3a0f:	08 83 02 02 f3 0a    	or     %al,0xaf30202(%ebx)
    3a15:	0e                   	push   %cs
    3a16:	04 c3                	add    $0xc3,%al
    3a18:	44                   	inc    %esp
    3a19:	0b 00                	or     (%eax),%eax
    3a1b:	00 18                	add    %bl,(%eax)
    3a1d:	00 00                	add    %al,(%eax)
    3a1f:	00 b4 00 00 00 9c f8 	add    %dh,-0x7640000(%eax,%eax,1)
    3a26:	ff                   	(bad)  
    3a27:	ff 24 00             	jmp    *(%eax,%eax,1)
    3a2a:	00 00                	add    %al,(%eax)
    3a2c:	00 41 0e             	add    %al,0xe(%ecx)
    3a2f:	08 83 02 62 0e 04    	or     %al,0x40e6202(%ebx)
    3a35:	c3                   	ret    
    3a36:	00 00                	add    %al,(%eax)
    3a38:	20 00                	and    %al,(%eax)
    3a3a:	00 00                	add    %al,(%eax)
    3a3c:	d0 00                	rolb   (%eax)
    3a3e:	00 00                	add    %al,(%eax)
    3a40:	b0 f8                	mov    $0xf8,%al
    3a42:	ff                   	(bad)  
    3a43:	ff 29                	ljmp   *(%ecx)
    3a45:	00 00                	add    %al,(%eax)
    3a47:	00 00                	add    %al,(%eax)
    3a49:	41                   	inc    %ecx
    3a4a:	0e                   	push   %cs
    3a4b:	08 86 02 41 0e 0c    	or     %al,0xc0e4102(%esi)
    3a51:	83 03 65             	addl   $0x65,(%ebx)
    3a54:	0e                   	push   %cs
    3a55:	08 c3                	or     %al,%bl
    3a57:	41                   	inc    %ecx
    3a58:	0e                   	push   %cs
    3a59:	04 c6                	add    $0xc6,%al
    3a5b:	00 2c 00             	add    %ch,(%eax,%eax,1)
    3a5e:	00 00                	add    %al,(%eax)
    3a60:	f4                   	hlt    
    3a61:	00 00                	add    %al,(%eax)
    3a63:	00 bc f8 ff ff 59 00 	add    %bh,0x59ffff(%eax,%edi,8)
    3a6a:	00 00                	add    %al,(%eax)
    3a6c:	00 41 0e             	add    %al,0xe(%ecx)
    3a6f:	08 86 02 41 0e 0c    	or     %al,0xc0e4102(%esi)
    3a75:	83 03 65             	addl   $0x65,(%ebx)
    3a78:	0a 0e                	or     (%esi),%cl
    3a7a:	08 c3                	or     %al,%bl
    3a7c:	41                   	inc    %ecx
    3a7d:	0e                   	push   %cs
    3a7e:	04 c6                	add    $0xc6,%al
    3a80:	48                   	dec    %eax
    3a81:	0b 67 c3             	or     -0x3d(%edi),%esp
    3a84:	0e                   	push   %cs
    3a85:	08 41 c6             	or     %al,-0x3a(%ecx)
    3a88:	0e                   	push   %cs
    3a89:	04 00                	add    $0x0,%al
    3a8b:	00 10                	add    %dl,(%eax)
    3a8d:	00 00                	add    %al,(%eax)
    3a8f:	00 24 01             	add    %ah,(%ecx,%eax,1)
    3a92:	00 00                	add    %al,(%eax)
    3a94:	ec                   	in     (%dx),%al
    3a95:	f8                   	clc    
    3a96:	ff                   	(bad)  
    3a97:	ff 1c 00             	lcall  *(%eax,%eax,1)
    3a9a:	00 00                	add    %al,(%eax)
    3a9c:	00 00                	add    %al,(%eax)
    3a9e:	00 00                	add    %al,(%eax)
    3aa0:	24 00                	and    $0x0,%al
    3aa2:	00 00                	add    %al,(%eax)
    3aa4:	38 01                	cmp    %al,(%ecx)
    3aa6:	00 00                	add    %al,(%eax)
    3aa8:	f8                   	clc    
    3aa9:	f8                   	clc    
    3aaa:	ff                   	(bad)  
    3aab:	ff 45 00             	incl   0x0(%ebp)
    3aae:	00 00                	add    %al,(%eax)
    3ab0:	00 41 0e             	add    %al,0xe(%ecx)
    3ab3:	08 86 02 41 0e 0c    	or     %al,0xc0e4102(%esi)
    3ab9:	83 03 7d             	addl   $0x7d,(%ebx)
    3abc:	0a 0e                	or     (%esi),%cl
    3abe:	08 c3                	or     %al,%bl
    3ac0:	41                   	inc    %ecx
    3ac1:	0e                   	push   %cs
    3ac2:	04 c6                	add    $0xc6,%al
    3ac4:	41                   	inc    %ecx
    3ac5:	0b 00                	or     (%eax),%eax
    3ac7:	00 3c 00             	add    %bh,(%eax,%eax,1)
    3aca:	00 00                	add    %al,(%eax)
    3acc:	60                   	pusha  
    3acd:	01 00                	add    %eax,(%eax)
    3acf:	00 20                	add    %ah,(%eax)
    3ad1:	f9                   	stc    
    3ad2:	ff                   	(bad)  
    3ad3:	ff 05 04 00 00 00    	incl   0x4
    3ad9:	41                   	inc    %ecx
    3ada:	0e                   	push   %cs
    3adb:	08 85 02 41 0e 0c    	or     %al,0xc0e4102(%ebp)
    3ae1:	87 03                	xchg   %eax,(%ebx)
    3ae3:	41                   	inc    %ecx
    3ae4:	0e                   	push   %cs
    3ae5:	10 86 04 41 0e 14    	adc    %al,0x140e4104(%esi)
    3aeb:	83 05 43 0e 4c 03 3a 	addl   $0x3a,0x34c0e43
    3af2:	01 0a                	add    %ecx,(%edx)
    3af4:	0e                   	push   %cs
    3af5:	14 41                	adc    $0x41,%al
    3af7:	0e                   	push   %cs
    3af8:	10 c3                	adc    %al,%bl
    3afa:	41                   	inc    %ecx
    3afb:	0e                   	push   %cs
    3afc:	0c c6                	or     $0xc6,%al
    3afe:	41                   	inc    %ecx
    3aff:	0e                   	push   %cs
    3b00:	08 c7                	or     %al,%bh
    3b02:	41                   	inc    %ecx
    3b03:	0e                   	push   %cs
    3b04:	04 c5                	add    $0xc5,%al
    3b06:	43                   	inc    %ebx
    3b07:	0b 28                	or     (%eax),%ebp
    3b09:	00 00                	add    %al,(%eax)
    3b0b:	00 a0 01 00 00 f0    	add    %ah,-0xfffffff(%eax)
    3b11:	fc                   	cld    
    3b12:	ff                   	(bad)  
    3b13:	ff                   	(bad)  
    3b14:	79 00                	jns    0x3b16
    3b16:	00 00                	add    %al,(%eax)
    3b18:	00 41 0e             	add    %al,0xe(%ecx)
    3b1b:	08 86 02 41 0e 0c    	or     %al,0xc0e4102(%esi)
    3b21:	83 03 46             	addl   $0x46,(%ebx)
    3b24:	0e                   	push   %cs
    3b25:	9c                   	pushf  
    3b26:	08 02                	or     %al,(%edx)
    3b28:	6e                   	outsb  %ds:(%esi),(%dx)
    3b29:	0e                   	push   %cs
    3b2a:	0c 41                	or     $0x41,%al
    3b2c:	0e                   	push   %cs
    3b2d:	08 c3                	or     %al,%bl
    3b2f:	41                   	inc    %ecx
    3b30:	0e                   	push   %cs
    3b31:	04 c6                	add    $0xc6,%al
    3b33:	00 10                	add    %dl,(%eax)
    3b35:	00 00                	add    %al,(%eax)
    3b37:	00 cc                	add    %cl,%ah
    3b39:	01 00                	add    %eax,(%eax)
    3b3b:	00 44 fd ff          	add    %al,-0x1(%ebp,%edi,8)
    3b3f:	ff 2a                	ljmp   *(%edx)
    3b41:	00 00                	add    %al,(%eax)
    3b43:	00 00                	add    %al,(%eax)
    3b45:	00 00                	add    %al,(%eax)
    3b47:	00 10                	add    %dl,(%eax)
    3b49:	00 00                	add    %al,(%eax)
    3b4b:	00 e0                	add    %ah,%al
    3b4d:	01 00                	add    %eax,(%eax)
    3b4f:	00 60 fd             	add    %ah,-0x3(%eax)
    3b52:	ff                   	(bad)  
    3b53:	ff 02                	incl   (%edx)
    3b55:	00 00                	add    %al,(%eax)
    3b57:	00 00                	add    %al,(%eax)
    3b59:	00 00                	add    %al,(%eax)
	...
