FXDIS is a simple Win32 command line tool written in C/C++ with the MIT license forked from the relatively new (and experimental) [Mesa](http://www.mesa3d.org/) ["D3D1X" module](http://cgit.freedesktop.org/mesa/mesa/commit/?id=92617aeac109481258f0c3863d09c1b8903d438b). This tool can disassemble [Shader Model 4/5 binary shaders](http://en.wikipedia.org/wiki/Shader_Model_4) created by Microsoft's DirectX v10/11 shader compiler. The decoded shader program can be easily accessed, potentially enabling the straightforward creation of low-level automated shader translation tools (for example, from compiled shader model 4/5 programs to GLSL) and simplifying the creation of a D3D 11 to OpenGL translation layer.

The tool can be compiled with Microsoft Visual Studio 2008/2010. This tool is completely standalone, i.e. it does not depend or include any headers from the Windows or DirectX SDK, and it does not rely on the Direct3D/D3DX runtime to function.

This tool surely has bugs, but after a few fixes it appears to be working surprisingly well. A huge thanks to Luca Barbieri (luca@luca-barbieri.com), the original author (and copyright holder) of this module. Also thanks to llyzs.vic@gmail.com for submitting his fixes (currently only checked into SVN).


---

## Revision History ##

Currently checked into SVN head only: More testing revealed broken dcl\_indexable\_temp disassembly, now fixed. Added more elaborate test.hlsl, converted tabs to spaces.

v0.90b [9/15/12] - Added missing fxdis.vcproj file to archive/SVN

v0.90 [9/15/12] - Initial release . Added MSVS project, a few MSVS compile fixes, integer constants literals should be printed correctly, and the disassembly of the various texture resource types is now properly handled. I'm continuing to test and refine this module as time permits.


---


## Testing ##

Make sure the DirectX SDK's bin folder is in your PATH (run the "DirectX SDK Command Prompt" shortcut), then run `test.bat`. This will run [FXC.EXE](http://msdn.microsoft.com/en-us/library/windows/desktop/bb509710(v=vs.85).aspx) to compile [test.hlsl](http://code.google.com/p/fxdis-d3d1x/source/browse/trunk/test.hlsl), a bogus sample shader. This compiler shader's disassembly will be printed twice - the first disassembly is from FXC.EXE, and the second disassembly is created by FXDIS.EXE.

Here's an example disassembly created by FXDIS of [test.hlsl](http://code.google.com/p/fxdis-d3d1x/source/browse/trunk/test.hlsl) (purposely compiled without optimizations in this test):

```
E:\dev\d3d1x_rel>fxc /Od /T ps_4_0 test.hlsl /Fo test.bin /Fc test.txt
Microsoft (R) Direct3D Shader Compiler 9.29.952.3111
Copyright (C) Microsoft Corporation 2002-2009. All rights reserved.

E:\dev\d3d1x_rel\test.hlsl(38,9): warning X3206: implicit truncation of vector type
E:\dev\d3d1x_rel\test.hlsl(56,7): warning X3206: implicit truncation of vector type
E:\dev\d3d1x_rel\test.hlsl(57,7): warning X3206: implicit truncation of vector type

compilation succeeded; see E:\dev\d3d1x_rel\test.txt
compilation succeeded; see E:\dev\d3d1x_rel\test.bin

E:\dev\d3d1x_rel>debug\fxdis.exe test.bin
# DXBC chunk  0: RDEF offset 52 size 468
# DXBC chunk  1: ISGN offset 528 size 104
# DXBC chunk  2: OSGN offset 640 size 44
# DXBC chunk  3: SHDR offset 692 size 2176
# DXBC chunk  4: STAT offset 2876 size 116
ps_4_0
dcl_constant_buffer cb0[129].xyzw, dynamicIndexed
dcl_sampler sampler[0]
dcl_resource_texture2d resource[0]
dcl_resource_texturecube resource[1]
dcl_resource_texture3d resource[2]
dcl_resource_texture2dms(2) resource[3]
dcl_input_ps linear v0.xyzw
dcl_input_ps linear centroid v1.x
dcl_input_ps_siv linear noperspective v2.x, position
dcl_output o0.xyzw
dcl_temps 3
ftou r0.x, v2.x
utof r0.x, r0.x
dp4 r0.y, v0.xyzw, l(0, 1, 2, 3)
add r0.x, r0.y, r0.x
add r0.x, r0.x, v1.x
xor r0.y, cb0[1].y, l(2)
itof r0.y, r0.y
add r0.x, r0.y, r0.x
mov r0.y, l(0)
mov r0.z, r0.x
mov r0.w, r0.y
loop
ilt r1.x, r0.w, l(10)
breakc r1.x
itof r1.x, r0.w
add r1.y, r1.x, l(1.001)
div r1.y, l(1), r1.y
mul r1.x, r1.y, r1.x
sqrt r1.y, r0.z
add r1.x, r1.y, r1.x
add r1.x, r0.z, r1.x
lt r1.y, r1.x, l(0)
if r1.y
mov r0.z, r1.x
break
endif
iadd r0.w, r0.w, l(1)
mov r0.z, r1.x
endloop
ftoi r0.x, r0.z
ilt r0.y, r0.x, l(0)
if r0.y
xor r0.y, r0.x, l(50)
else
ilt r1.x, l(5), r0.x
if r1.x
and r0.y, r0.x, l(2222)
else
iadd r0.y, r0.x, -cb0[r0.x+2].x
endif
endif
add r0.x, cb0[0].y, cb0[0].x
add r0.x, r0.x, cb0[0].z
add r0.x, r0.x, cb0[0].w
add r0.x, r0.x, r0.z
sample r1.xyzw, l(0.125, 5, 0, 0), resource[0].xyzw, sampler[0]
add r0.x, r0.x, r1.x
sample r1.xyzw, l(0.125, 5, 1, 0), resource[1].xyzw, sampler[0]
add r0.x, r0.x, r1.x
sample r1.xyzw, l(0.125, 5, 1, 0), resource[2].xyzw, sampler[0]
add r0.x, r0.x, r1.z
ldms r1.xyzw, l(0, 5, 0, 0), resource[3].xyzw, l(0)
add r1.x, r0.x, r1.x
div r1.y, l(1), r1.x
sample_b r2.xyzw, r1.xyxx, resource[0].xyzw, sampler[0], l(-15)
add r0.x, r1.x, r2.y
and r0.y, r0.y, l(556677)
iadd r0.y, r0.y, l(42)
ishr r0.y, r0.y, l(76)
ishl r0.y, r0.y, l(22)
mov r0.y, r0.y
xor r0.z, r0.y, r0.y
ushr r0.z, r0.z, l(3)
ishl r0.z, r0.z, l(2)
mov r1.x, cb0[r0.z+2].x
xor r0.z, r0.z, r1.x
and r1.x, r0.z, l(127)
mov r1.x, cb0[r1.x+2].x
and r0.z, r0.z, r1.x
iadd r1.x, r0.z, l(66)
iadd r1.y, r0.z, l(1)
imul null, r1.x, cb0[r1.x+2].y, cb0[r1.y+2].x
itof r1.x, r1.x
add r0.x, r0.x, r1.x
mul o0.z, r0.x, l(0.2)
utof r0.x, r0.z
add o0.w, r0.x, l(0.5)
itof o0.x, r0.w
itof o0.y, r0.y
ret
```