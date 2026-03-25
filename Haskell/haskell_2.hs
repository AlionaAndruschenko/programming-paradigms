processList :: [Int] -> (Int, [Int], [Int])
processList [] = (0, [], [])
processList (x:xs)
    | x == 0    = (z + 1, p, n)
    | x > 0     = (z, x:p, n)
    | otherwise = (z, p, x:n)
  where
    (z, p, n) = processList xs

main :: IO ()
main = do
    let xs = [1, 0, -3, 4, 0, -2, 5, 0, -1]
    let (zeros, positives, negatives) = processList xs
    print zeros
    print positives
    print negatives
