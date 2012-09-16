cbuffer cbuf0
{
   float4 cool;
   int4 zeek;
   int2 arr[127];
};

sampler samp0;
Texture2D <float4> tex0;
TextureCube <float4> tex1;
Texture3D <float4> tex2;
Texture2DMS <float4,2> tex3;

float4 main( 
   float4 t0 : TEXCOORD0,
   float4 t1 : TEXCOORD1_centroid,
   float4 p0 : SV_POSITION
   ) : SV_TARGET
{
   float j = (uint)p0.x + dot(t0, float4(0,1,2,3)) + t1.x + (zeek.y ^ 2);
   for ( int i = 0; i < 10; i++ )
   {
      j += i * (1.0f/(i+(1.001))) + sqrt( j );
      if (j < 0)
         break;
   }
   int q = (int)j;
   if ( q < 0 )
   {
      q ^= 50;
   }
   else if ( q > 5 )
   {
      q &= 2222;
   }
   else
   { 
      q -= arr[q];
   }
   
   j += cool.x + cool.y + cool.z + cool.w;
   j += tex0.Sample( samp0, float2( 0.125f, 5.0f ) ).x;
   j += tex1.Sample( samp0, float3( 0.125f, 5.0f, 1.0 ) ).x;
   j += tex2.Sample( samp0, float3( 0.125f, 5.0f, 1.0 ) ).z;
   j += tex3.Load( int2( 0.125f, 5.0f ), 0, 1 ).x;
   j += tex0.SampleBias( samp0, float2( j, 1/j ), -15 ).y;
   
   q &= 556677;
   q |= 42;
   q >>= 76;
   q <<= 22;
   unsigned int qu = q;
   qu ^= q;
   qu >>= 3;
   qu <<= 2;
   qu ^= arr[qu];
   qu &= arr[qu & 127];
   j += arr[qu+66].y * arr[qu+1].x;
      
   return float4(i,q,j*.2,qu + .5f);
}
