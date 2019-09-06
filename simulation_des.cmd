

File {
  * Input Files
  Grid = "n@node|estructura@_msh.tdr"  
  plot = "n@Vds@_@Ldrain@_@Lchannel@_@Workfu@_@Quantization@_@ucontact@_@uchannel@_TL_@masstl@_@epsilon@_@alphahor@_@alphavert@_@alpha@_des.tdr"
  current = "n@Vds@_@Ldrain@_@Lchannel@_@Workfu@_@Quantization@_@ucontact@_@uchannel@_TL_@masstl@_@epsilon@_@alphahor@_@alphavert@_@alpha@_des.plt"          
  Output  = "n@node@"
  param = "@parameter@"
  PMIPath="pmi"

}

CurrentPlot{
*write dimensions
eDensity ( Integrate(region="semi1" Window[(0.01975 0) (0.02 @Wbottom@)] ))

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



Physics{
Fermi
EffectiveIntrinsicDensity( NoBandGapNarrowing )  

}


Physics (Material="InGaAs"){
	MoleFraction(xFraction=0.47)

Fermi
eQuasiFermi = 0

#if @<"@MobilityModel@" == "ConstantMobility">@
   eMobility(@MobilityModel@) 
 #endif 

#if "@Quantization@"=="DG"

     eQuantumPotential(Density)
     eMultiValley(Nonparabolicity)
     
#elif "@Quantization@"=="DGA"

     eQuantumPotential(AutoOrientation)
     Aniso(eQuantumPotential(Direction(SimulationSystem)=(1,0,0)))
   	     eMultiValley(Nonparabolicity)
     	

#elif "@Quantization@"=="MLDA"
 	eMultivalley(MLDA Nonparabolicity)
 
#elif "@Quantization@"=="NONE"
     eMultiValley(Nonparabolicity)

#endif

##LayerThickness(Thickness=@Wbottom@, DimensionWeight=2)	  



}



Math {
  Digits=4
  Number_of_Threads=2
  ComputeGradQuasiFermiAtContacts=UseQuasiFermi
  CurrentPlot( IntegrationUnit = cm )
}    


 #if @<"@Quantization@" == "DG" || "@Quantization@" == "DGA" >@


Solve { 
coupled {Poisson}
coupled{Poisson eQuantumPotential}

  Quasistationary(
      InitialStep=0.005 MinStep=1e-4 Maxstep=0.01
	            Increment=1.3 

      Goal { Name="drain_c0" Voltage=@Vds@} #!!!
  ){ 
      coupled{poisson eQuantumPotential }
       
  } 
  NewCurrentPrefix = "Ninv_"
  Quasistationary(
      InitialStep=0.001 MinStep=1e-5 Maxstep=0.005
	            Increment=1.3 

      Plot { Range=(0,1) Intervals=16}
 #     AcceptNewtonParameter (ReferenceStep = 5.0e-4)
      Goal { Name="bottom" Voltage=@VG_END@}
      Goal { Name="top" Voltage=@VG_END@}
  ){ 
      coupled{poisson eQuantumPotential }
      CurrentPlot (Time=(range=(0.0 1.0) intervals=16))
  }  

  
}

#else

Solve { 
coupled{Poisson }

  Quasistationary(
      InitialStep=0.005 MinStep=1e-4 Maxstep=0.01
	            Increment=1.3 

      Goal { Name="drain_c0" Voltage=@Vds@} #!!!
  ){ 
      coupled{poisson }
       
  } 
  NewCurrentPrefix = "Ninv_"
  Quasistationary(
      InitialStep=0.001 MinStep=1e-5 Maxstep=0.005
	            Increment=1.3 


 #     AcceptNewtonParameter (ReferenceStep = 5.0e-4)
      Goal { Name="bottom" Voltage=@VG_END@}
      Goal { Name="top" Voltage=@VG_END@}
  ){ 
      coupled{poisson }
      CurrentPlot (Time=(range=(0.0 1.0) intervals=16))
  }  

  
}
#endif
