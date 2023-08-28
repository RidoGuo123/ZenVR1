//////该Shader仅作用于CustomRenderTexture//////

Shader "MIT_VirtualClassroom/CustomRenderTexture/UnderWaterCaustics"
{
    Properties
    {
        [NoScaleOffset]_CausticTex("Caustic Texture", 2D) = "white" {}
        [NoScaleOffset]_FlowmapTex("Flowmap Texture", 2D) = "grey" {}              
        
        _CausticIntensity("Caustic Intensity", Float) = 1.0
        _CausticFalloff("Caustic Falloff", Float) = 1.0
        _FlowmapIntensity("Flowmap Intensity", Float) = 0.05
        _GlobalSpeed("Global Speed", Float) = 1.0
        
        [Space(10)][Foldout(1,3,0,1)]_Foldout1("Advanced Options_Foldout", float) = 1
        _CausticSpeed_1("Caustic 1 Speed", Float) = 0.05
        _CausticSpeed_2("Caustic 2 Speed", Float) = -0.075
        _CausticSpeed_3("Caustic 3 Speed", Float) = 0.1
        [IntRange]_CausticScale_1("Caustic 1 Scale", Range(1,10)) = 1
        [IntRange]_CausticScale_2("Caustic 2 Scale", Range(1,10)) = 2
        [IntRange]_CausticScale_3("Caustic 3 Scale", Range(1,10)) = 3
        [IntRange]_FlowmapScale_1("Flowmap 1 Scale", Range(1,10)) = 1
        [IntRange]_FlowmapScale_2("Flowmap 2 Scale", Range(1,10)) = 2
        [IntRange]_FlowmapScale_3("Flowmap 3 Scale", Range(1,10)) = 3

        [Foldout(1,3,0,1)]_Foldout3("Others_Foldout", float) = 1       
        
     }

     SubShader
     {
        Lighting Off
        Blend One Zero

        Pass
        {
            HLSLPROGRAM
            #include "UnityCustomRenderTexture.cginc"
            #pragma vertex CustomRenderTextureVertexShader
            #pragma fragment frag
            #pragma target 3.0

            sampler2D   _CausticTex;
            sampler2D   _FlowmapTex;
            half    _CausticScale_1;
            half    _CausticScale_2;
            half    _CausticScale_3;
            half    _FlowmapScale_1;
            half    _FlowmapScale_2;
            half    _FlowmapScale_3;
            half    _GlobalSpeed;
            half    _CausticSpeed_1;
            half    _CausticSpeed_2;
            half    _CausticSpeed_3;
            half    _FlowmapIntensity;
            half    _CausticIntensity;
            half    _CausticFalloff;


            half3 frag(v2f_customrendertexture IN) : COLOR
            {
                half2 uv = IN.localTexcoord;

                half2 uv1 = _CausticScale_1 * (uv + tex2D(_FlowmapTex, uv * _FlowmapScale_1).rg * _FlowmapIntensity);
				half2 uv2 = _CausticScale_2 * (uv + tex2D(_FlowmapTex, uv * _FlowmapScale_2).rg * _FlowmapIntensity);
				half2 uv3 = _CausticScale_3 * (uv + tex2D(_FlowmapTex, uv * _FlowmapScale_3).rg * _FlowmapIntensity);
                half Caustic_1 = tex2D(_CausticTex, uv1 + _Time.y * _CausticSpeed_1 * _GlobalSpeed + 0.146958);
				half Caustic_2 = tex2D(_CausticTex, uv2 + _Time.y * _CausticSpeed_2 * _GlobalSpeed + 0.254676);
				half Caustic_3 = tex2D(_CausticTex, uv3 + _Time.y * _CausticSpeed_3 * _GlobalSpeed + 0.324657);
				half Caustics = (Caustic_1 + Caustic_2) * Caustic_3;

                Caustics = pow(Caustics, _CausticFalloff) * _CausticIntensity;


                return Caustics;
            }
            ENDHLSL
            }
    }

    CustomEditor "metis.innovate.arts.SimpleShaderGUI"
}