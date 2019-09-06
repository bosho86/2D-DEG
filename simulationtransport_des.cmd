  
      #if @<"@Tunneling@" == "NLT">@

     #define _P2_  eBarrierTunneling "NLM2"

   
     #define _M2_  Nonlocal "NLM2" (
     #define _M22_ RegionInterface="semi1/drain"
     #define _M222_ Length=@Lchannel@e-4
     #define _M2222_ Permeation=0.1e-7	)
     
   #else


     #define _P2_  

     #define _M2_ 
     #define _M22_ 
     #define _M222_
     #define _M2222_ 

   #endif



  
      #if @<"@Tunneling@" == "NLTMV">@

     #define _P2_ eBarrierTunneling "NLM2" (MultiValley) 

   
     #define _M2_  Nonlocal "NLM2" (
     #define _M22_ RegionInterface="semi1/drain"
     #define _M222_ Length=@Lchannel@e-4
     #define _M2222_ Permeation=0.1e-7	)
     
   #else


     #define _P2_  

     #define _M2_ 
     #define _M22_ 
     #define _M222_
     #define _M2222_ 

   #endif


  
        #if @<"@MobilityModel@" == "BallisticmattQF">@
     #define _MOVMODEL_  HighFieldSaturation(
    #define _PMI_      PMIModel(
     #define _NAME_   Name="pmi_HighFieldMobility2mattQF"
     #define _INDEX_  Index="1"
     #define _STRING_ String= "n"))

     
     

   #endif
   





File {
  * Input Files
  Grid = "n@node|estructura@_msh.tdr"  
  plot = "n@Vds@_@Ldrain@_@Lchannel@_@Workfu@_@Quantization@_@ucontact@_@uchannel@_@Tunneling@_@masstl@_@alphahor@_@alphavert@_@mctunneling@_des.tdr"
  current = "n@Vds@_@Ldrain@_@Lchannel@_@Workfu@_@Quantization@_@ucontact@_@uchannel@_@Tunneling@_@masstl@_@alphahor@_@alphavert@_@mctunneling@_des.plt"          
  Output  = "n@node@"
  param = "@parameter@"
  PMIPath="pmi"

}


plot {SRH eSRHRecombination hSRHRecombination tSRHRecombination eTrappedCharge  Auger
  eVelocity/Vector eCurrent/Vector hCurrent/Vector ElectricField/Vector
  eDensity hdensity potential
  DopingConcentration eQuasiFermi eGradQuasiFermi Mod_eGradQuasiFermi_ElectricField hQuasiFermi
  eMobility hMobility
  ConductionBandEdge ValenceBandEdge
  eBand2BandGeneration hBand2BandGeneration Band2Band eQuasiFermiEnergy ConductionBandEnergy
  eQuantumPotential
 
}


Electrode {
  { Name="source_c0"     Voltage=0.0 }
  { Name="drain_c0"      Voltage=0.0 }
  { Name="top"            Voltage=@Vinit@  Material="Tungsten"}
  { Name="bottom"         Voltage=@Vinit@  Material="Tungsten"}
}





Physics (Material="InGaAs"){
	MoleFraction(xFraction=0.47)

Fermi
eQuasiFermi = 0


}

Physics(region=drain)
{

eMobility(ConstantMobility)
 eMultiValley(Nonparabolicity)


}


Physics(region=source)
{

eMobility(ConstantMobility)
 eMultiValley(Nonparabolicity)
 


}

Physics(Region=semi1)

{



#if @<"@MobilityModel@" == "BallisticmattQF">@
    eMobility( 
     _MOVMODEL_  
     _PMI_   
      _NAME_  
      _INDEX_ 
      _STRING_ 
  
   )
   
#endif

#if @<"@MobilityModel@" == "ConstantMobility">@
   eMobility(@MobilityModel@) 
 #endif 
   eMultiValley(Nonparabolicity )
    
  
}
 
 
Physics{ 

Fermi
EffectiveIntrinsicDensity( NoBandGapNarrowing )  
 
  #if @<"@Tunneling@" == "NLT">@
  
  eBarrierTunneling "NLM2" 
   


  #elif @<"@Tunneling@" == "NLTMV">@
  
eBarrierTunneling "NLM2" (MultiValley) 

  #endif 



 
 #if "@Quantization@"=="DG"

     eQuantumPotential(Density)

     
#elif "@Quantization@"=="DGA"

     eQuantumPotential(AutoOrientation)
     Aniso(eQuantumPotential(Direction(SimulationSystem)=(1,0,0)))
 
#elif "@Quantization@"=="NONE"

#endif
  
    

}



Math {
  Digits=4
  Number_of_Threads=2
  ComputeGradQuasiFermiAtContacts=UseQuasiFermi

  *Tunneling
  #if @<"@Tunneling@" == "NLT">@ 
      Nonlocal "NLM2" (
   RegionInterface="semi1/drain"
      Length=@Lchannel@e-4
   Permeation=0.1e-7	)


  #elif @<"@Tunneling@" == "NLTMV">@ 
 Nonlocal "NLM2" (
 RegionInterface="semi1/drain"
 Length=@Lchannel@e-4
   Permeation=0.1e-7	)
  #endif
  

}    





 #if @<"@Quantization@" == "DG" || "@Quantization@" == "DGA" >@


Solve { 
coupled {Poisson}
coupled {Poisson electron hole}
coupled{Poisson eQuantumPotential electron hole}

  Quasistationary(
      InitialStep=0.005 MinStep=1e-4 Maxstep=0.01
	            Increment=1.3 

      Goal { Name="drain_c0" Voltage=@Vds@} #!!!
  ){ 
      coupled{poisson eQuantumPotential electron hole }
       
  } 
    Quasistationary(
      InitialStep=0.001 MinStep=1e-5 Maxstep=0.005
	            Increment=1.3 

      Plot { Range=(0,1) Intervals=16}
 #     AcceptNewtonParameter (ReferenceStep = 5.0e-4)
      Goal { Name="bottom" Voltage=@VG_END@}
      Goal { Name="top" Voltage=@VG_END@}
  ){ 
      coupled{poisson eQuantumPotential electron hole}
      CurrentPlot (Time=(range=(0.0 1.0) intervals=16))
  }  

  
}

#else

Solve { 
coupled{Poisson }
coupled{Poisson electron hole }
  Quasistationary(
      InitialStep=0.005 MinStep=1e-4 Maxstep=0.01
	            Increment=1.3 

      Goal { Name="drain_c0" Voltage=@Vds@} #!!!
  ){ 
      coupled{poisson electron hole }
       
  } 

  Quasistationary(
      InitialStep=0.001 MinStep=1e-5 Maxstep=0.005
	            Increment=1.3 


 #     AcceptNewtonParameter (ReferenceStep = 5.0e-4)
      Goal { Name="bottom" Voltage=@VG_END@}
      Goal { Name="top" Voltage=@VG_END@}
  ){ 
      coupled{poisson electron hole }
      CurrentPlot (Time=(range=(0.0 1.0) intervals=16))
  }  

  
}
#endif
