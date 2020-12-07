import taichi as tc

r = 100

if __name__ == '__main__':
  mpm = tc.dynamics.MPM(
      gravity=(0, 0),
      res=(r + 1, r + 1, r + 1),
      frame_dt=0.02,
      base_delta_t=0.0003,
      num_frames=300,)

  levelset = mpm.create_levelset()
  #levelset.add_plane(tc.Vector(0.0, 1, 0), -0.4)
  #levelset.add_plane(tc.Vector(1, 0, 0), -0.4)
  levelset.set_friction(-1)
  mpm.set_levelset(levelset, False)


  tex = tc.Texture('rect', bounds=(0.05, 0.05, 0.05)) * 400

#  tex = tc.Texture(
 #     'mesh',
  #    translate=(0, 0, 0),
   #   adaptive=False,
    #  filename='$mpm/damascusBox.obj')

  mpm.add_particles(
      type='von_mises',
      pd=True,
      density_tex=tex.id,
      initial_velocity=(0, 0, 0),
      density=800,
      color=(0.8, 0.7, 1.0),
      initial_position=(0,0,0),
      #E=1.5e3,
      #nu=0.4
      youngs_modulus=1.5e4,
      poisson_ratio=.25,
      yield_stress=20000.0,
      )


  def position_function1(t):
    if t < 5:
    	return tc.Vector(.55 - t/133, 0.5, 0.5)
    else:
        return tc.Vector(.55 - 5/133 + (t-5)/80,  0.5, 0.5)

  def position_function2(t):
    if t < 5:
    	return tc.Vector(0.5, .55 - t/133, 0.5)
    else:
        return tc.Vector(0.5, .55 - 5/133 + (t-5)/80, 0.5)

  def position_function3(t):
    if t < 5:
    	return tc.Vector(.45 + t/133, 0.5, 0.5)
    else:
        return tc.Vector(.45 + 5/133 - (t-5)/80, 0.5, 0.5)

  def position_function4(t):
    if t < 5:
    	return tc.Vector(0.5, .45 + t/133, 0.5)
    else:
        return tc.Vector(0.5, .45 + 5/133 - (t-5)/80, 0.5)

  def rotation_function1(_):
    return tc.Vector(90, 90, 0)
  def rotation_function2(_):
    return tc.Vector(0,0,0)

  mpm.add_particles(
      type='rigid',
      density=10,
      scale=(.8, .8, .8),
      friction=0,
      scripted_position=tc.function13(position_function1),
      scripted_rotation=tc.function13(rotation_function1),
      codimensional=True,
      mesh_fn='$mpm/flat_cutter_medium_res.obj')

  mpm.add_particles(
      type='rigid',
      density=10,
      scale=(.8, .8, .8),
      friction=0,
      scripted_position=tc.function13(position_function2),
      scripted_rotation=tc.function13(rotation_function2),
      codimensional=True,
      mesh_fn='$mpm/flat_cutter_medium_res.obj')

  mpm.add_particles(
      type='rigid',
      density=10,
      scale=(.8, .8, .8),
      friction=0,
      scripted_position=tc.function13(position_function3),
      scripted_rotation=tc.function13(rotation_function1),
      codimensional=True,
      mesh_fn='$mpm/flat_cutter_medium_res.obj')

  mpm.add_particles(
      type='rigid',
      density=10,
      scale=(.8, .8, .8),
      friction=0,
      scripted_position=tc.function13(position_function4),
      scripted_rotation=tc.function13(rotation_function2),
      codimensional=True,
      mesh_fn='$mpm/flat_cutter_medium_res.obj')
  mpm.simulate(clear_output_directory=True)
