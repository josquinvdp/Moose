# [Mesh]
#   type = GeneratedMesh
#  dim = 3
#  xmax = 10.0
#  ymax = 10
#  zmax = 10
#  nx = 20
#  ny = 10
#  nz = 10
#  #construct_side_set_from_node_set=true
# []



[Mesh]
	[./fmg]
		type = FileMeshGenerator
		file = Composite.msh
	[]
	[./rename]
		 type = RenameBlockGenerator
		 old_block_id = '1 2'
		 new_block_name = 'matrix particle'
		 input = 'fmg'
		 ## break the mesh
	 [../]
	 [./breakmesh]
		 type = BreakMeshByBlockGenerator
		 input = fmg
		 interface_name= 'interface1'
		 #split_interface = true
	 []
[]


[MeshModifiers]

[./surface1]
type = BoundingBoxNodeSet
 new_boundary = 's' #### the name you specify
 bottom_left = '0 0 0' #### xmin ymin zmin
 top_right = '100 0 100' #xmax ymin+a zmax #### change to adjust your size
[../]

[./surface2]
 type = BoundingBoxNodeSet
 new_boundary = 'w' #### the name you specify
 bottom_left = '0 0 0' #### change to adjust your size
 top_right = '0 100 100' #x y z #### change to adjust your size
[../]
[./surface3]
 type = BoundingBoxNodeSet
new_boundary = 'n' #### the name you specify
 bottom_left = '0.0 100 0.0' #### change to adjust your size
 top_right = '100 100 100' #x y z #### change to adjust your size
[../]
[./surface4]
 type = BoundingBoxNodeSet
 new_boundary = 'o' #### the name you specify
 bottom_left = '100 0.0 0.0' #### change to adjust your size
 top_right = '100 100 100' #x y z #### change to adjust your size
[../]
[./surface5]
 type = BoundingBoxNodeSet
 new_boundary = 'b' #### the name you specify
 bottom_left = '0.0 0.0 0.0' #### change to adjust your size
 top_right = '100 100 0.0' #x y z #### change to adjust your size
[../]
[./surface6]
 type = BoundingBoxNodeSet
 new_boundary = 't'
 bottom_left = '0.0 0 100'
 top_right = '100 100 100'  #x y z
[../]
[]
# []

[Variables]
  # Need to have variable for each block to allow discontinuity
 # [T1]
 #  block = 0
 # []
 # [T2]
 #  block = 1
 # []
 [T]
  #block = 2
 []

 # [T1_X]
 #  #block = 2
 # []
[]

[Kernels]
  # Diffusion kernel for each block's variable
 [diff_1_x]  # for direct method
   type = HeatConduction
  variable = T
  diffusivity = diffusion_coefficient
  #block = 0
  []

  # [diff_1_x_rh]  #
  #   type = HeatConduction
  #  variable = T1_X
  #  diffusivity = diffusion_coefficient
  #  #block = 0
  #  []
 # [diff_2_x]
 #  type = HeatConduction
 #  variable = T2
 #  diffusivity = diffusion_coefficient
 #  block = 1
 #  []
 # [./heat_rhs_x_1]
 #   type = HomogenizedHeatConduction
 #   variable = T1_X
 #   component = 0     #An integer corresponding to the direction this pp acts in (0 for x, 1 for y, 2 for z)
 # [../]
 []

[InterfaceKernels]

  [gapx]
   type = SideSetHeatTransferKernel1
   variable = T
   neighbor_var = T
   boundary = 'interface1'
  []

  # [gapx_T1x]
  #  type = SideSetHeatTransferKernel1
  #  variable = T1_X
  #  neighbor_var = T1_X
  #  boundary = interface
  # []

[]
  [AuxVariables]
    # Dependent variables
    [./dT_dx]
      order = FIRST
      family = MONOMIAL
    [../]

    [./dT_dx_dif]
      order = FIRST
      family = MONOMIAL
    [../]

    #
    # [T]
    # order = FIRST
    # family = LAGRANGE
    # []

  []

  [AuxKernels]
    [DIFF_FLUX1]
      type = DiffusionFluxAux
      diffusion_variable = T
      variable = dT_dx_dif
      component= x
      diffusivity= 'thermal_conductivity'
    [../]
    #[DIFF_FLUX2]
    #  type= DiffusionFluxAux
    #  component= x
    #  diffusion_variable = T2
    #  diffusivity= 'thermal_conductivity'
    #[../]

    [./grad_T_x]
      # AuxKernel that calculates the GB term
      type = VariableGradientComponent
      gradient_variable = T
      variable = dT_dx
      component = x
      execute_on = 'initial timestep_end'
    [../]

    # [temp1_X]
    #   type = NormalizationAux
    #  variable = T
    #  source_variable = T1
    #  block = 0
    #  [../]
    #  [temp1_Y]
    #   type = NormalizationAux
    #   variable = T
    #   source_variable = T2
    #   block = 1
    #  [../]
  []

[BCs]
  # [./Periodic]
  #  [./all]
  #    auto_direction = 'x'
  #    variable = 'T1_X '
  #  [../]
  # [../]

  [bc_left_x]
    type = DirichletBC
    boundary = 'w'
    variable = T
    value = 400.0
  []

  [bc_left_Y]
    type = DirichletBC
    boundary = 'o'
    variable = T
    value = 800.0
  []

[]

[Materials]
  [Block1]
    type = GenericConstantMaterial
    prop_names = 'thermal_conductivity'
    prop_values = '9'
    block = 'matrix'
  []

  [Block2]
    type = GenericConstantMaterial
    prop_names = 'thermal_conductivity'
    prop_values = '1'
    block = 'particle'
  []

  # Interface material used for SideSetHeatTransferKernel
   #Heat transfer meachnisms ignored if certain properties are not supplied
   [gap_mat]
     type = SideSetHeatTransferMaterial
     boundary = 'interface1'
     conductivity = 0.01
     gap_length = 1
	 ##thermal_conductivity = 41
   []
[]

[Executioner]
  type = Steady
  nl_rel_tol = 1e-8
  l_tol = 1e-5
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -ksp_gmres_restart'
  petsc_options_value = 'lu       superlu_dist                  100'
	automatic_scaling = true
  compute_scaling_once = false
	#IterationAdaptiveDT
[]

[Outputs]
  exodus = true
[]

[Postprocessors]
  [./k_xx_direct_calculating]
    type = HomogenizedThermalConductivity2
    variable = T
    temp_x = T
    component = 0
[../]

# [./k_xx_T1x]
#   type = HomogenizedThermalConductivity
#   variable = T1_X
#   temp_x = T1_X
#   component = 0
# [../]

# [./gradient_with_diffussion]
#   type = ElementAverageValue_new
#   variable = dT_dx
  #variable = dT_dx

  #temp_x = Tx

  #component = 0
# [../]

# [./gradient_with_dif0]
#   type = ElementAverageValue
#   variable = dT_dx_dif
  #variable = dT_dx
# block = 0
  #temp_x = Tx
# [../]
# [./gradient_with_dif1]
#   type = ElementAverageValue
#   variable = dT_dx_dif
#   #variable = dT_dx
#  block = 1
#   #temp_x = Tx
# [../]


# [./gradient_check_block0]
#   type = ElementAverageValue
#   variable = dT_dx
#   block = 0
# [../]
#
# [./gradient_check_block1]
#   type = ElementAverageValue
#   variable = dT_dx
#   block = 1
# [../]
#   [./k_yy]
#     type = HomogenizedThermalConductivity
#     variable = Ty
#     temp_x = Tx
#     temp_y = Ty
#     temp_z = Tz
#     component = 1
#  [../]
#  [./k_zz]
#     type = HomogenizedThermalConductivity
#     variable = Tz
#     temp_x = Tx
#     temp_y = Ty
#     temp_z = Tz
#     component = 2
#   [../]
  # [inlet_heat_fluxl]
  #   type = SideFluxAverage
  #   variable = dT_dx
  #   boundary = left
  #   diffusivity = thermal_conductivity
  # [../]
  #
  # [outlet_heat_fluxr]
  #   type = SideFluxAverage
  #   variable = dT_dx
  #   boundary = right
  #   diffusivity = thermal_conductivity
  # [../]

  # [inlet_heat_fluxt]
  #   type = SideFluxIntegral
  #   variable = Tx
  #   boundary = top
  #   diffusivity = thermal_conductivity
  # [../]
  #
  # [outlet_heat_fluxb]
  #   type = SideFluxIntegral
  #   variable = Tx
  #   boundary = bottom
  #   diffusivity = thermal_conductivity
  # [../]
  # [inlet_heat_fluxb]
  #   type = SideFluxIntegral
  #   variable = Tx
  #   boundary = back
  #   diffusivity = thermal_conductivity
  # [../]
  #
  # [outlet_heat_fluxf]
  #   type = SideFluxIntegral
  #   variable = Tx
  #   boundary = front
  #   diffusivity = thermal_conductivity
  #[../]
[]
