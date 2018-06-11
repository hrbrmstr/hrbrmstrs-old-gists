library(mosaic)

duration <- 40

plot.new()
soln <- integrateODE(dD~(1.05*(D-600)) * (1-(D/1300)), D=797, tdur=duration)
plotFun(soln$D(t)~t, tlim=range(1, duration), col="red",
        xlab="Years out", ylab="Population (thousands)", main="Deer population model",
        ylim=c(0, 1500))

soln1 <- integrateODE(dD~((1.05*(D-600)) * (1-(D/1300))-K), D=797, K=1, tdur=duration)
plotFun(soln1$D(t)~t, tlim=range(1, duration), col="blue", add=TRUE)

soln2 <- integrateODE(dD~((1.05*(D-600)) * (1-(D/1300))-K), D=797, K=10, tdur=duration)
plotFun(soln2$D(t)~t, tlim=range(1, duration), col="blue", add=TRUE)

soln3 <- integrateODE(dD~((1.05*(D-600)) * (1-(D/1300))-K), D=797, K=25, tdur=duration)
plotFun(soln3$D(t)~t, tlim=range(1, duration), col="green", add=TRUE)

soln4 <- integrateODE(dD~((1.05*(D-600)) * (1-(D/1300))-K), D=797, K=50, tdur=duration)
plotFun(soln4$D(t)~t, tlim=range(1, duration), col="orange", add=TRUE)

soln5 <- integrateODE(dD~((1.05*(D-600)) * (1-(D/1300))-K), D=797, K=75, tdur=duration)
plotFun(soln5$D(t)~t, tlim=range(1,duration ), col="purple", add=TRUE)

soln6 <- integrateODE(dD~((1.05*(D-600)) * (1-(D/1300))-K), D=797, K=80, tdur=duration)
plotFun(soln6$D(t)~t, tlim=range(1,duration ), col="maroon", add=TRUE)

soln7 <- integrateODE(dD~((1.05*(D-600)) * (1-(D/1300))-K), D=797, K=81, tdur=duration)
plotFun(soln7$D(t)~t, tlim=range(1,duration ), col="black", add=TRUE)

soln0 <- integrateODE(dD~((1.05*(D-600)) * (1-(D/1300))-K), D=797, K=-20, tdur=duration)
plotFun(soln0$D(t)~t, tlim=range(1, duration), col="yellow", add=TRUE)
