Shader "Custom/Banded-TS"

  {
    Properties
    { 
        _MainTex("Main Texture", 2D) = "white" {}                               // REPRESENTA TEXTURA

        _Albedo("Albedo Color", Color) = (1, 1, 1, 1)                           // COLOR, RGBA (_ALBEDO)
        
        _NormalTex("Normal Texture", 2D) = "bump" {}                            //NORMAL (PARA PORDER NORMALIZ)
        _NormalStrength("Normal Strength", Range(-5.0, 5.0)) = 1.0

        _FallOff("Max falloff", Range(0.0, 0.5)) = 0.0                          // WRAP
        
        _SpecularColor("Specular Color", Color) = (1, 1, 1, 1)                  // PHONG (EFECTO PUNTO BRILLANTE)
        _SpecularPower("Specular Power", Range(1.0, 10.0)) = 5.0
        _SpecularGloss("Specular Gloss", Range(1.0, 5.0)) = 1.0
        _GlossSteps("GlossSteps", Range(1, 8)) = 4

        [HDR] _EmissionColor("EmissionColor", Color) = (1, 1, 1, 1)             //RIM (LUZ ORILLA)
        _RimPower("Rim Power", Range(0.0, 8.0)) = 1.0

        _RampTex("Ramp Texture", 2D) = "white" {}                               // RAMP TEXTURE (EFECTOS CUADROS DEGRADADOS)

        _Steps("Banded Steps", Range(1, 100)) = 20                              // BANDED (EFECTO RAMP TEXTURE)
        
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
        }
        
        CGPROGRAM

        #pragma surface surf Toon

        sampler2D _MainTex;  //TEXTURA
        sampler2D _RampTex;  //RAMP TEXTURE
        sampler2D _NormalTex; //NORMAL

        half4 _Albedo;                   //COLOR

        float _NormalStrength;           //NORMAL

        half _FallOff;                  //WRAP

        half4 _SpecularColor;           //PHONG
        half _SpecularPower;
        half _SpecularGloss;
        int _GlossSteps;

        float4 _EmissionColor;          //RIM
        float _RimPower;

        fixed _Steps;                  //BANDED

        half4 LightingToon(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
        {
            half3 reflectedLight = reflect(-lightDir, s.Normal);                                                        //EFECTO PHONG
            half RdotV = max(0, dot(reflectedLight, viewDir));
            half3 specularity = pow(RdotV, _SpecularGloss / _GlossSteps) * _SpecularPower * _SpecularColor.rgb;
            half NdotL = dot(s.Normal, lightDir);
            half lot = NdotL * 0.5 + 0.5;

            half diff = NdotL * _FallOff + _FallOff;                                                                    //EFECTO WRAP
            half lightBandsMultiplier = _Steps / 256;
            half lightBandsAdditive = _Steps / 2;

            float x = NdotL * 0.5 + 0.5;                                                                                // EFECTO RIM
            float2 uv_RampTex = float2(x, 0);
            half4 rampColor = tex2D(_RampTex, uv_RampTex);

            fixed bandedLightModel = (floor((NdotL * 256  + lightBandsAdditive) / _Steps)) * lightBandsMultiplier;      //EFECTO BANDED
            
            half4 c;
            c.rgb = lot * (NdotL * s.Albedo + specularity) * _LightColor0.rgb * rampColor * atten * bandedLightModel * diff;
            c.a = s.Alpha;
            return c;
        }

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
            float2 uv_NormalTex;

            fixed a;   
        };

        void surf(Input IN, inout SurfaceOutput o)
        {   
            half4 mainTexColor = tex2D(_MainTex, IN.uv_MainTex);         //TEXTURA
            
            o.Albedo = mainTexColor * _Albedo;                           //COLOR

            half4 normalColor = tex2D(_NormalTex, IN.uv_NormalTex);      //MAPA DE NORMALES
            half3 normal = UnpackNormal(normalColor);
            normal.z = normal.z / _NormalStrength;
            o.Normal = normalize(normal);           

            float3 viewDirNormalized= normalize(IN.viewDir);            //PRIM
            float VdotN = dot(viewDirNormalized, o.Normal);
            fixed rim = 1 - saturate(VdotN);
            o.Emission = _EmissionColor * pow(rim, _RimPower);
        }

        ENDCG
    }
}