module Client.PostClient where
import Client.SaveClient
import Client.ModelClient
import Client.GetSetAttrsClient

-- ====================== addAsset =========================== --
-- Entrada: id: int / companyID: Int / price: Float
-- TipoDeSaida: Bool
addAsset :: Int -> Int -> Int -> IO Bool
addAsset clientID companyID qtd = do
    let client = getClient clientID

    if (ident client) /= -1 then do    
        let recoveryAssetsClient = allAssets client

        if (existAssetInClient (allAssets client) companyID) then do
            let newExistentAssets = addExistentAssetInCompany recoveryAssetsClient companyID qtd
            setAllAssets clientID newExistentAssets
            putStrLn ("\nOlá" ++ (name client) ++ "! A compra da ação foi concluída e incrementada!")
            return True

        else do
            let newAllAssets = [(createAsset companyID qtd)] ++ recoveryAssetsClient
            if (length newAllAssets) <= 11 then do
                setAllAssets clientID newAllAssets
                putStrLn ("\nOlá " ++ (name client) ++ "! A compra da ação foi concluída!")
                return True
            else do
                putStrLn "\nOcorreu um  probelama! Quantidade de ações excedida."
                return False
    else do
        putStrLn "\nOcorreu um problema! O Cliente com este id não foi encontrado!"
        return False

existAssetInClient :: [Asset] -> Int -> Bool
existAssetInClient [] _ = False
existAssetInClient (x:xs) id =
    if (companyID x) == id then
        True
    else
        existAssetInClient xs id

addExistentAssetInCompany :: [Asset] -> Int -> Int -> [Asset]
addExistentAssetInCompany [] _ _= []
addExistentAssetInCompany (x:xs) idCompany qtd = [addQtd x idCompany qtd] ++ addExistentAssetInCompany xs idCompany qtd

addQtd :: Asset -> Int -> Int -> Asset
addQtd asset idCompany qtd_ =
    if (companyID asset) == idCompany then
        asset { qtd = (qtd asset) + qtd_ }
    else
        asset