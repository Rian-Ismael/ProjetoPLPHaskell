module HomeBroker.HomeBrokerUpdate where

import Utils.MatrixUtils (writeMatrixValue)
import Utils.UpdateUtils (fillLeft, getNewTrendIndicator)

updateHBStockPrice :: FilePath -> Float -> Float -> IO ()
updateHBStockPrice filePath oldPrice newPrice = do
    let val = fillLeft (getTrendIndicator oldPrice newPrice ++ show newPrice) 3
    writeMatrixValue filePath val 11 (94 - length val)

updateHBStockMaxPrice :: FilePath -> Float -> IO ()
updateHBStockMaxPrice filePath num = do
    let val = fillLeft (show num) 4
    writeMatrixValue filePath val 16 (94 - length val)


updateHBStockMinPrice :: FilePath -> Float -> IO ()
updateHBStockMinPrice filePath num = do
    let val = fillLeft (show num) 4
    writeMatrixValue filePath val 18 (94 - length val)


updateHBStockStartPrice :: FilePath -> Float -> IO ()
updateHBStockStartPrice filePath num = do
    let val = fillLeft (show num) 4
    writeMatrixValue filePath val 14 (94 - length val)


updateHBCash :: FilePath -> Float -> IO ()
updateHBCash filePath num = do
    let val = fillLeft (show num) 8
    writeMatrixValue filePath val 3 (76 - length val)

updateHBOwnedStocks :: FilePath -> Int -> IO ()
updateHBOwnedStocks filePath num = do
    let val = fillLeft (show num) 5
    writeMatrixValue filePath val 21 (95 - length val)


updateHBStockName :: FilePath -> String -> IO ()
updateHBStockName filePath name = do
    writeMatrixValue filePath name 3 47


updateHBCompanyName :: FilePath -> String -> IO ()
updateHBCompanyName filePath name = do
    writeMatrixValue filePath name 7 (getCompanyNameCol (length name))


getCompanyNameCol :: Int -> Int
getCompanyNameCol len = 86 - ((len - 1) `div` 2)
