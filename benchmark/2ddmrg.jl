using ITensors

function main()
  Ny = 6
  Nx = 12

  N = Nx*Ny

  sites = siteinds("S=1/2",N)

  lattice = squareLattice(Nx,Ny,yperiodic=false)
  #lattice = triangularLattice(Nx,Ny,yperiodic=false)

  ampo = AutoMPO(sites)
  for b in lattice
    add!(ampo,0.5,"S+",b.s1,"S-",b.s2)
    add!(ampo,0.5,"S-",b.s1,"S+",b.s2)
    add!(ampo,    "Sz",b.s1,"Sz",b.s2)
  end
  H = toMPO(ampo)

  state = [isodd(n) ? "Up" : "Dn" for n=1:N]
  psi0 = productMPS(sites,state)

  sweeps = Sweeps(10)
  maxdim!(sweeps,10,20,100,100,200,400,800)
  cutoff!(sweeps,1E-8)
  @show sweeps

  energy,psi = dmrg(H,psi0,sweeps)

end
main()
