[Mesh]
  type = GeneratedMesh
 dim = 3
 xmax = 100.0
 ymax = 100
 zmax = 100
 nx = 100
 ny = 10
 nz = 10
[]
[MeshModifiers]
  [block_1]
   type = SubdomainBoundingBox
   bottom_left = '45.0 45.0 45.0'
     top_right = '65.0 55.0 55.0'
   block_id = 1
  []
#  [./block2]
#   type = SubdomainBoundingBox
#   bottom_left = '15.0 45.0 45.0'
#     top_right = '25.0 55.0 55.0'
#   block_id = 1
# [../]
#   [./block3]
#   type = SubdomainBoundingBox
#   bottom_left = '45.0 45.0 45.0'
#     top_right = '55.0 55.0 55.0'
#   block_id = 2
# [../]
#   [./block4]
#   type = SubdomainBoundingBox
#   bottom_left = '75.0 45.0 45.0'
#  top_right = '85.0 55.0 55.0'
#   block_id = 3
# [../]
 
[]


[MeshModifiers]
 [./interface]
  type = BreakMeshByBlock
  split_interface = true
 [../]
[]

 [MeshModifiers]

 [./surface1]
 type = BoundingBoxNodeSet
  new_boundary = 's' #### the name you specify
  bottom_left = '0 0 0' #### xmin ymin zmin
  top_right = '100 0 100' #xmax ymin+a zmax #### change to adjust your size
 [../]##

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
  bottom_left = '100 0.0 0.0' #### change to adjust your size#
 top_right = '100 100 100' #x y z #### change to adjust your s#ize
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
 []#
 