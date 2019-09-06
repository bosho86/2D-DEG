
set DG_data	[load_file Ninv_n@Vds@_@Ldrain@_@Lchannel@_@Workfu@_@Quantization@_@ucontact@_@uchannel@_TL_@masstl@_@epsilon@_@alphahor@_@alphavert@_@alpha@_des.plt]
set myplot [create_plot -1d]
set mydata1 [load_file "Ninv_@Lchannel@noparabolic_des.plt"]


set label "sDevice"
create_curve -plot $myplot -dataset $DG_data -axisX {top OuterVoltage} -axisY {IntegrWindow((0.01975,0),(0.02,@Wbottom@)) eDensity}
create_curve -plot Plot_1 -name Curve_2 -function <Curve_1>/2.5e-8
set_curve_prop -plot Plot_1 Curve_2 -label Sdevice -color red -show_markers -markers_size 7

  
set label "QTx"
create_curve -plot $myplot -dataset $mydata1 -axisX {top InnerVoltage} -axisY {drain_c0 TotalCurrent}
remove_curves -plot Plot_1 Curve_1
set_curve_prop -plot Plot_1 Curve_3 -label QTx -color black -show_markers -markers_size 7


set NinvUnits "cm-2"
set_axis_prop -axis y -title "Ninv \[$NinvUnits\]" -title_font_size 25 -scale_font_size 20
  
 
# Set x-axis properties
set_axis_prop -axis x -title "V(gate) \[V\]" -title_font_size 25 -scale_font_size 20  

set_axis_prop -plot Plot_1 -axis y -type log

set title "@Material@ tbody=@Wbottom@ um WF=@Workfu@"
set_plot_prop -plot Plot_1 -title $title -title_font_size 20
