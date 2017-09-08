       program radial
c
c   Calculates the radial density distribution from
c   a distribution of galactocentric radius...
c
       implicit none
       integer i,lun,nbins,col
       real r,nr(99),rho(99),rmin,rmax,nmax,delta,err(99),pi,
     &      gal(99),rhomax,el(99),eh(99),factor,r1,r2,nl(99)
       real ldeg,bdeg,ppsr,width,dmp,tau,freq,lmin,lmax,logl,
     &                tsky,dtrue,dderi,lpsr,s,si,x,y,z
       integer narg,iargc,lpop,lcline,ngen,nfreq,n
       character*80 filename,cline*240

       call getarg(1,filename)
       if (filename.eq.' ') stop 'usage: radial popfile'
       pi=3.1415927
       lun=10
       nbins=15
       rmin=0.0
       rmax=15.0
       lmin=-2
       lmax=3.5
       do i=1,99
          nr(i)=0.0
          nl(i)=0.0
       enddo
c
c     Read the sources generated by psrdist in from disk
c
      call glun(lpop)
      open(lpop,file=filename,form="unformatted")
      read(lpop) lcline,cline
      read(lpop) ngen,freq
      write(*,*) ngen
      do i=1,ngen
         read(lpop) ldeg,bdeg,ppsr,width,dmp,tau,
     &                tsky,dtrue,dderi,lpsr,s,si
         call calc_xyz(ldeg,bdeg,dtrue,x,y,z)
         r=sqrt(x*x+y*y)
         call bindata(r,rmin,rmax,nbins,nr)
         logl=log10(lpsr)
         call bindata(logl,lmin,lmax,nbins,nl)
      enddo
      close(lpop)
       
       nmax=0.0
       do i=1,nbins
         nmax=max(nmax,nr(i))
       enddo

       open(lpop,file='radial.dat',status='unknown')
       rhomax=0.0
       delta=(rmax-rmin)/float(nbins)
       do i=1,nbins
         gal(i)=delta/2.0+float(i-1)*delta
         if (i.gt.1) then
            factor=pi*((delta*float(i))**2-(delta*float(i-1))**2)
         else
            factor=pi*delta*delta
         endif
         rho(i)=nr(i)/factor
         err(i)=sqrt(rho(i))
         el(i)=rho(i)-err(i)
         eh(i)=rho(i)+err(i)
         rhomax=max(eh(i),rhomax)
         logl=lmin+(lmax-lmin)*(real(i)-0.5)/real(nbins)
         write(lpop,*) gal(i),rho(i),10.0**logl,nl(i)
       enddo
       close(lpop)
       rhomax=rhomax*1.1


       call pgbegin(0,'?',1,1)
       call pgscf(2)
       call pgsch(1.5)
       call pgvport(0.15,0.85,0.15,0.85)
       call pgwindow(rmin,rmax,0.0,rhomax*1.1)
       call pgbox('bcnst',0.0,0,'bcnst',0.0,0)
       call pglabel('Galactocentric Radius (kpc)',
     &              "\\gr(R) (PSRs kpc\\u-2\\d)",' ')
       call pgpoint(nbins,gal,rho,17)
       call pgerry(nbins,gal,el,eh,1.0)
       call pgend
       end
       
      subroutine bindata(x,xmin,xmax,nbins,nx)
      implicit none
      real x,xmin,xmax,nx(*)
      integer n,nbins
      n=(x-xmin)/(xmax-xmin)*nbins+1
      if (n.ge.1.and.n.le.nbins) nx(n)=nx(n)+1.0
      end
