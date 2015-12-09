This project builds on Kevin Murphy's PMTK Matlab library. It is essenntial that
this library be both installed and currently within the working path.

The primary Matlab scripts are:
  - cartSim
  - svmSim

These scripts, respectively, execute the Random Forest and SVMs implementations 
of the stock market predictors. Each script will generate a series of figures 
summarizing the results for the various experimental setups.

Also, ensure that the directory ../datasets is in Matlab's PATH in order to make 
the datasets visible to the scripts. Alternatively, copy the MAT files to ./source.

NOTE: In order to suppress warnings, the following changes to quadprog.m (in 
Matlab's optimization tool kit) and svmQPclassFit.m (in PMTK's SupervisedModels 
toolbox) had to be made. The code will run without these changes; this is only
a cosmetic change:



-------------------------------------------------------------------------------
quadprog.m, Line 375: Changes require administrative privileges 

WAS:
	        warning(message('optim:quadprog:WillRunDiffAlg',linkTag,endLinkTag,'interior-point-convex'));

IS:
	        % warning(message('optim:quadprog:WillRunDiffAlg',linkTag,endLinkTag,'interior-point-convex'));
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
svmQPclassFit.m, Line 40:

WAS:
			options = optimset('LargeScale', 'off', 'MaxIter', 1000, 'display', 'off');

IS:
	        options = optimset('LargeScale', 'on', 'MaxIter', 1000, 'display', 'off', 'Algorithm','active-set');
-------------------------------------------------------------------------------
