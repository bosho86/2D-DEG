/*********************************************************************************************************************************
Definition of a wire structure:

1) the order of the parameters must not be changed
2) the points in the structure mat_coord(i,j) and ox_coord(i,j) must follow the order described below
3) comments must remain on one line or start again with //

Commands:

Bandstructure		= conduction bandstructure of contacts
Transmission_PWF	= conduction band transmission with PARDISO
Transmission_UWF	= conduction band transmission with UMFPACK
Transmission_SWF	= conduction band transmission with SuperLU_DIST
SC_PWF			= self-consistent electron simulation with PARDISO
SC_UWF			= self-consistent electron simulation with UMFPACK
SC_SWF			= self-consistent electron simulation with SuperLU_DIST

*********************************************************************************************************************************/
/*Parameters*/

poisson_criterion	= 1e-3;
poisson_iteration	= 120;

NDim			= 2;

Temp           		= 300.0;				//operation temperature

mode_space		= [1 16];
recompute_basis		= 1;

plot_transmission = 1;
plot_dos		= 1;
plot_modes		= 1;
plot_valleys  		= 1;

n_of_modes		= 16;              		//number of modes for bandstructure calculation
Nk			= 251;                           //number of k points in bandstructure calculation. High Nk important for good energy grid in pMOS

last_first		= 0;                    	//last super cell is equal to first super cell if last_first=1

eta			= 0.0;				//imaginary part of the energy in the device

Elimit			= 50e-3;                	//energy interval after a mode where the energy grid is finer (should not be changed)
Emin_tail		= 20.0e-3;			//energy interval below the lowest band (should not be changed)
EOffset                 = 25*UT;			//Emax = Emin + EOffset or Emax = max(Efl,Efr) + EOffset
dE_in			= 5.0e-4;			//smallest energy interval (should not be changed)
dE_f			= 1.0e-3;			//largest energy interval (should not be changed)
dE_sep			= 1.0e-4;			//distance between a channel turn-on and the following energy point (should not be changed)
NEmax			= 100;				//maximum number of calculated energy point

CPU_ppoint		= 1;				//number of CPUs per energy point, must be a divider of mpi_size

n_of_valleys		= 1;
deg_factor		= 1;
alpha_np 		= 0;

//Si Channel
Eg_wire                 = 0.0;
Xi_wire                 = 4.633;
Eps_wire                = 13.6420;
me_x_wire               = 0.0516;
me_y_wire               = 0.0516;
me_z_wire               = 0.0516;

//HfO2: electron affinity: 2.1 [eV]
Eg_ox                  = 2.58;          //Band Offset between Si and HfO2 [eV]
Eps_ox                 = 22.0;
me_x_ox                = 0.2;
me_y_ox                = 0.2;
me_z_ox                = 0.2;

Eg_gate			= 0.0;
Eps_gate		= 13.64;
me_x_gate		= 1.0;
me_y_gate		= 1.0;
me_z_gate		= 1.0;	
phi_m			= 4.8;                 	//Gate work function

dEc			= 1.0;				//band gap offset

NVG			= 15;				//number of gate voltages Vg=Vgmin:(Vgmax-Vgmin)/(NVG-1):Vgmax
Vgmin                   = -0.2;				//absolute minimum gate potential
Vgmax                   = 0.6 ;				//absolute maximum gate potential

NVS			= 1;				//number of source voltages Vs=Vsmin:(Vsmax-Vsmin)/(NVS-1):Vsmax
Vsmin                   = 0.0;				//absolute minimum source potential
Vsmax                   = 0.0;				//absolute maximum source potential

NVD			= 1;				//number of drain voltages Vd=Vdmin:(Vdmax-Vdmin)/(NVD-1):Vdmax
Vdmin                   = 0.0;				//absolute minimum drain potential
Vdmax                   = 0.0;				//absolute maximum drain potential

//directory		= ;

/*********************************************************************************************************************************/
/*Structure*/

no_mat			= 7; 		//number of pieces that form the device 

Lc			= 40.0;     			//channel length
Ls			= 25.0;  			//source length
Ld			= 25.0;				//drain length
ts			= 7.0;
td			= 7.0;
tc			= 7.0;
hox			= 3.75;

dx			= 0.25;
xmin 			= 0.0;
xmax 			= Ls+Lc+Ld;
 
dy			= 0.25;
ymin			= 0.0-hox;
ymax 			= ts+hox;

ND_S			= 5e25;				//donator concentration in source  [m^{-3}]
NA_S			= 1e12;				//acceptor concentration in source [m^{-3}]
ND_D			= 5e25;				//donator concentration in drain   [m^{-3}]
NA_D			= 1e12;				//acceptor concentration in drain  [m^{-3}]

mat_Eg(1)		= Eg_wire;		
mat_Eps(1)		= Eps_wire;
mat_me_x(1)		= me_x_wire;
mat_me_y(1)		= me_y_wire;
mat_me_z(1)		= me_z_wire;
mat_V(1)		= 0.0;
mat_contact(1)		= 0;
mat_ND(1)		= ND_S;
mat_NA(1)		= NA_S;
mat_type(1)		= square;
mat_coord(1,1)		= [0.0 0.0];		//[xmin ymin]
mat_coord(1,2)		= [Ls 0.0];		//[xmax ymim]
mat_coord(1,3)		= [Ls ts];		//[xmax ymax]
mat_coord(1,4)		= [0.0 ts];		//[xmin ymax]

mat_Eg(2)		= Eg_wire;		
mat_Eps(2)		= Eps_wire;
mat_me_x(2)		= me_x_wire;
mat_me_y(2)		= me_y_wire;
mat_me_z(2)		= me_z_wire;
mat_V(2)		= 0.0;
mat_contact(2)		= 0;
mat_ND(2)		= 0.0;
mat_NA(2)		= 1e23;
mat_type(2)		= square;
mat_coord(2,1)	        = [Ls 0.0];          	//[xmin ymin]
mat_coord(2,2)		= [Ls+Lc 0.0];		//[xmax ymin]
mat_coord(2,3)		= [Ls+Lc tc];		//[xmax ymax]
mat_coord(2,4)		= [Ls tc];			//[xmin ymax]

mat_Eg(3)		= Eg_wire;
mat_Eps(3)		= Eps_wire;
mat_me_x(3)		= me_x_wire;
mat_me_y(3)		= me_y_wire;
mat_me_z(3)		= me_z_wire;
mat_V(3)		= 0.0;
mat_contact(3)		= 0;
mat_ND(3)		= ND_D;
mat_NA(3)		= NA_D;
mat_type(3)		= square;
mat_coord(3,1)		= [Ls+Lc 0.0];		//[xmin ymin]
mat_coord(3,2)		= [Ls+Lc+Ld 0.0];		//[xmax ymin]
mat_coord(3,3)		= [Ls+Lc+Ld td];		//[xmax ymax]
mat_coord(3,4)		= [Ls+Lc td];		//[xmin ymax]

//top oxide on the Channel 
mat_Eg(4)		= Eg_ox;	
mat_Eps(4)		= Eps_ox;
mat_me_x(4)		= me_x_ox;
mat_me_y(4)		= me_y_ox;
mat_me_z(4)		= me_z_ox;
mat_V(4)		= dEc*(Eg_ox-Eg_wire);
mat_contact(4)		= 0;
mat_ND(4)		= 0.0;
mat_NA(4)		= 0.0;
mat_type(4)		= square;
mat_coord(4,1)	        = [0.0 ts];          	//[xmin ymin]
mat_coord(4,2)		= [Ls+Lc+Ld ts];		//[xmax ymin]
mat_coord(4,3)		= [Ls+Lc+Ld ts+hox];		//[xmax ymax]
mat_coord(4,4)		= [0.0 ts+hox];		//[xmin ymax]

//top oxide on the Source and Drain 
mat_Eg(5)		= Eg_ox;	
mat_Eps(5)		= Eps_ox;
mat_me_x(5)		= me_x_ox;
mat_me_y(5)		= me_y_ox;
mat_me_z(5)		= me_z_ox;
mat_V(5)		= dEc*(Eg_ox-Eg_wire);
mat_contact(5)		= 0;
mat_ND(5)		= 0.0;
mat_NA(5)		= 0.0;
mat_type(5)		= square;
mat_coord(5,1)	        = [0.0 0.0];          	//[xmin ymin]
mat_coord(5,2)		= [Ls+Lc+Ld 0.0];		//[xmax ymin]
mat_coord(5,3)		= [Ls+Lc+Ld 0.0-hox];		//[xmax ymax]
mat_coord(5,4)		= [0.0 0.0-hox];		//[xmin ymax]

//Top Gate 
mat_Eg(6)		= Eg_gate;
mat_Eps(6)		= Eps_gate;
mat_me_x(6)		= me_x_gate;
mat_me_y(6)		= me_y_gate;
mat_me_z(6)		= me_z_gate;
mat_V(6)		= 0.0;
mat_contact(6)		= 1;				//leakage current=2 
mat_ND(6)		= 0.0;
mat_NA(6)		= 0.0;
mat_type(6)		= square;
mat_coord(6,1)		= [Ls ts+hox];
mat_coord(6,2)		= [Ls+Lc ts+hox];
mat_coord(6,3)		= [Ls+Lc ts+hox];
mat_coord(6,4)		= [Ls ts+hox];

//Bottom Gate 
mat_Eg(7)		= Eg_gate;
mat_Eps(7)		= Eps_gate;
mat_me_x(7)		= me_x_gate;
mat_me_y(7)		= me_y_gate;
mat_me_z(7)		= me_z_gate;
mat_V(7)		= 0.0;
mat_contact(7)		= 1;				//leakage current=2 
mat_ND(7)		= 0.0;
mat_NA(7)		= 0.0;
mat_type(7)		= square;
mat_coord(7,1)		= [Ls 0.0-hox];
mat_coord(7,2)		= [Ls+Lc 0.0-hox];
mat_coord(7,3)		= [Ls+Lc 0.0-hox];
mat_coord(7,4)		= [Ls 0.0-hox];

/*********************************************************************************************************************************/
/*Commands*/

command(1)		= Bandstructure;
command(2)              = SC_UWF;			//maximum command number = 20
