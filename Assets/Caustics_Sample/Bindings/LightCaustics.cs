using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEngine.Rendering.HighDefinition;

/////////////////////////////
//用于模拟水下的焦散灯光效果//
////////////////////////////

[ExecuteInEditMode]
public class LightCaustics : MonoBehaviour
{
    [Header("*将脚本附到主光源上,以下值会自动搜索*")]
    [SerializeField]
    Light MainLight;
    [SerializeField]
    HDAdditionalLightData MainLightHDRP;
    [SerializeField]
    Shader CausticShader;
    [SerializeField]
    Material CausticsMat;
    [SerializeField]
    CustomRenderTexture CRT;


    [Header("*使用默认或自行设置*")]
    [SerializeField]
    Texture2D CausticTex;
    [SerializeField]
    Texture2D FlowmapTex;

    [SerializeField]
    float GlobalScale = 2f;
    [SerializeField]
    float GlobalSpeed = 1f;

    [SerializeField]
    float CausticIntensity = 1f;
    [SerializeField]
    float CausticFalloff = 1f;
    [SerializeField]
    float FlowmapIntensity = 0.05f;
    

    
    int RTsize = 512;
    RenderTextureFormat RTformat = RenderTextureFormat.ARGBHalf;  


    // Start is called before the first frame update
    void OnEnable()
    {
        MainLight = GetComponent<Light>();
        MainLightHDRP = GetComponent<HDAdditionalLightData>();
        if(!CausticShader)
        {
            CausticShader = Shader.Find("MIT_VirtualClassroom/CustomRenderTexture/UnderWaterCaustics");
        }

        CausticsMat = new Material(CausticShader);
        CRT = new CustomRenderTexture(RTsize,RTsize,RTformat,RenderTextureReadWrite.Linear);
        CRT.depthStencilFormat = UnityEngine.Experimental.Rendering.GraphicsFormat.None;
        CRT.useMipMap = true;
        CRT.wrapMode = TextureWrapMode.Repeat;
        CRT.initializationMode = CustomRenderTextureUpdateMode.OnDemand;
        CRT.material = CausticsMat;
        CRT.updateMode = CustomRenderTextureUpdateMode.Realtime;
        CRT.Initialize();

        MainLight.cookie = CRT;        
    }

    // Update is called once per frame
    void Update()
    {
        CausticsMat.SetTexture("_CausticTex", CausticTex);
        CausticsMat.SetTexture("_FlowmapTex", FlowmapTex);
        CausticsMat.SetFloat("_CausticIntensity",CausticIntensity);
        CausticsMat.SetFloat("_CausticFalloff",CausticFalloff);
        CausticsMat.SetFloat("_FlowmapIntensity",FlowmapIntensity);
        CausticsMat.SetFloat("_GlobalSpeed",GlobalSpeed);
        
        //MainLightHDRP.lightCookieSize = new Vector2(GlobalScale,GlobalScale);        
    }

}
