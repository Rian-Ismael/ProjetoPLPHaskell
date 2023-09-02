module Company.CreateCompany where

import Company.GetInfoForCreateCompany
import Company.ModelCompany

getCompany :: IO Company
getCompany = do
  companyName <- getName
  companyAgeFounded <- getAgeFounded
  companyCNPJ <- getCNPJ
  companyActuation <- getActuation
  companyDeclaration <- getDeclaration
  companyCode <- getCode
  return $ createCompany 10 companyName companyAgeFounded companyCNPJ companyActuation companyDeclaration companyCode 30.0
