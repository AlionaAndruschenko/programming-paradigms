{-26. Розбити заданий список на N списків відповідно з числами, що мають вигляд Nk, Nk+1, Nk+2, … Nk+(N-1)
для деякого цілого k. (Критерій розбиття – значення остачі при діленні на N).-}
getGroup :: Int -> Int -> [Int] -> [Int]
getGroup n r [] = []
getGroup n r (x:xs)
    | x `mod` n == r = x : getGroup n r xs
    | otherwise      = getGroup n r xs

splitByMod :: Int -> [Int] -> [[Int]]
splitByMod n xs = buildGroups n xs 0
  where
    buildGroups n xs r
        | r >= n    = []
        | otherwise = getGroup n r xs : buildGroups n xs (r + 1)

main :: IO ()
main = do
    let xs = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    let n = 3
    let result = splitByMod n xs
    mapM_ print result
