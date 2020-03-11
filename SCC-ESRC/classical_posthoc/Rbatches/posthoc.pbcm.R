# data-informed (post hoc) PBCM analysis. Generator functions reside
# in generate.pbcm.R.
posthoc.pbcm <- function(data, # in long format
                         genargs1,
                         genargs2,
                         model1,
                         model2,
                         budget,
                         reps,
                         k,
                         npb = FALSE) {
  # set arguments
  fun1 <- cre::fit.cre.nls
  fun2 <- cre::fit.cre.nls
  args1 <- list(format="long", model=model1, budget=budget, warnOnly=TRUE)
  args2 <- list(format="long", model=model2, budget=budget, warnOnly=TRUE)
  genfun1 <- generate.datainformed
  genfun2 <- generate.datainformed
  genargs1$modeltype <- model1
  genargs2$modeltype <- model2

  # get distros, holdout set and empirical DeltaRSS
  distros <- pbcm::pbcm.di(data=data, fun1=fun1, fun2=fun2, args1=args1, args2=args2, genfun1=genfun1, genfun2=genfun2, genargs1=genargs1, genargs2=genargs2, reps=reps, GoFname="cumul_objfun_value", verbose=FALSE, nonparametric_bootstrap=npb)
  holdout <- pbcm::pbcm.di(data=data, fun1=fun1, fun2=fun2, args1=args1, args2=args2, genfun1=genfun1, genfun2=genfun2, genargs1=genargs1, genargs2=genargs2, reps=reps, GoFname="cumul_objfun_value", verbose=FALSE, nonparametric_bootstrap=npb)
  empirical <- pbcm::empirical.GoF(data=data, fun1=fun1, fun2=fun2, args1=args1, args2=args2, verbose=FALSE, GoFname="cumul_objfun_value")
  empirical <- pbcm::kNN.classification(df=distros, DeltaGoF.emp=empirical$DeltaGoF, k=k, ties="model2", verbose=FALSE)

  # get alpha and beta by comparing holdout against distros
  confusion <- pbcm::kNN.confusionmatrix(df=distros, df.holdout=holdout, k=k)

  # return
  distros$set <- "distribution"
  holdout$set <- "holdout"

  distros$model1 <- model1
  holdout$model1 <- model1
  confusion$model1 <- model1
  empirical$model1 <- model1

  distros$model2 <- model2
  holdout$model2 <- model2
  confusion$model2 <- model2
  empirical$model2 <- model2

  distros$case <- paste0(model1, "_v_", model2)
  holdout$case <- paste0(model1, "_v_", model2)
  confusion$case <- paste0(model1, "_v_", model2)
  empirical$case <- paste0(model1, "_v_", model2)

  list(raw=rbind(distros, holdout), alphabeta=confusion, empirical=empirical)
}
