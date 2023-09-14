module Menus.HomeBroker.HomeBrokerAttPrice where

import System.Random (randomRIO)

import Utils.MatrixUtils (printMatrix)
import Utils.HomeBrokerGraphUtils (attCompanyLineRow, attTrendIndicator)

import Menus.HomeBroker.HomeBrokerUpdate (updateHBGraphCandle, updateHBStockMaxPrice, updateHBStockMinPrice, updateHBStockPrice, updateHBStockStartPrice)
import Menus.HomeBroker.CompanyDown.CompanyDownUpdate (isDown, removeComapanyFromExchange)

import Company.ModelCompany (Company)
import Company.GetSetAttrsCompany (getCol, getIdent, getMaxPrice, getMinPrice, getPrice, getRow, getStartPrice, getTrendIndicator, setMaxPrice, setMinPrice, setPrice)


-- Retorna um index e uma variação aleatória 
getIndexAndVariation :: IO [Int]
getIndexAndVariation = do
    index <- randomRIO (0,9 :: Int)
    var <- randomRIO (-1,1 :: Int)
    return [index, var]


-- Retorna um novo preço baseado na aleatóriedade da função getIndexAndVariation
getNewPrice :: Float -> IO Float
getNewPrice oldPrice = do
    indexVar <- getIndexAndVariation
    if last indexVar == 1 then return (format (([0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0] !! head indexVar) + oldPrice))
    else if last indexVar == (-1) then return (format (([-0.1, -0.2, -0.3, -0.4, -0.5, -0.6, -0.7, -0.8, -0.9, -1.0] !! head indexVar) + oldPrice))
    else return oldPrice
    where
        format :: Float -> Float
        format newPrice = fromIntegral (round (newPrice * 10 )) / 10


-- Retorna o novo preço máximo baseado no novo preço
getNewMaxPrice :: Int -> Float -> IO Float
getNewMaxPrice idComp newPrice = do
    let maxPrice = getMaxPrice idComp
    if maxPrice >= newPrice then return maxPrice 
    else do
        setMaxPrice idComp newPrice 
        return newPrice


-- Retorna o novo preço mínimo baseado no novo preço
getNewMinPrice :: Int -> Float -> IO Float
getNewMinPrice idComp newPrice = do
    let minPrice = getMinPrice idComp
    if minPrice <= newPrice then return minPrice 
    else do
        setMinPrice idComp newPrice 
        return newPrice


-- Atualiza o preço e o gráfico em todas as empresas cadastradas
attAllCompanyPriceGraph :: Int -> [Company] -> IO ()
attAllCompanyPriceGraph _ [] = return ()
attAllCompanyPriceGraph idComp (x:xs)
    | randomId == idComp = do
        attCurrentCompanyPriceGraph idComp
        attAllCompanyPriceGraph idComp xs
    | isDown randomId = do
        removeComapanyFromExchange randomId
        attAllCompanyPriceGraph idComp xs
    | otherwise = do
        attCompanyPriceGraph randomId
        attAllCompanyPriceGraph idComp xs
    where
        randomId = getIdent x


-- Atualiza na empresa atual, a partir do seu ID, o preço e o gráfico
attCurrentCompanyPriceGraph :: Int -> IO ()
attCurrentCompanyPriceGraph id = do
    attCompanyPriceGraph id
    printMatrix ("./Company/HomeBroker/homebroker" ++ show id ++ ".txt")


-- Atualiza em uma empresa qualquer, a partir do seu ID, o preço e o gráfico
attCompanyPriceGraph :: Int -> IO ()
attCompanyPriceGraph id = do
    let oldPrice = getPrice id
    newPrice <- getNewPrice oldPrice
    newMaxPrice <- getNewMaxPrice id newPrice
    newMinPrice <- getNewMinPrice id newPrice

    setPrice id newPrice
    attTrendIndicator id oldPrice newPrice
    attCompanyLineRow id oldPrice newPrice
    updateHBStockPrice filePath newPrice (getTrendIndicator id)
    updateHBStockMaxPrice filePath newMaxPrice
    updateHBStockMinPrice filePath newMinPrice
    updateHBStockStartPrice filePath (getStartPrice id)
    updateHBGraphCandle filePath (getRow id) (getCol id)
    where filePath = "./Company/HomeBroker/homebroker" ++ show id ++ ".txt"