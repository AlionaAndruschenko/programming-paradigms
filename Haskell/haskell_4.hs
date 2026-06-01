{-
  Задача 4 (11+3 балів).
  Виявити праворекурсивні нетермінали граматики.
-}


type NT      = String
type Term    = Char

data Symbol  = N NT | Te Term
  deriving (Eq, Show)

type Rule    = (NT, [Symbol])
type Grammar = [Rule]


myNub :: Eq a => [a] -> [a]
myNub []     = []
myNub (x:xs) = x : myNub (filter (/= x) xs)

nonterminals :: Grammar -> [NT]
nonterminals g = myNub [ a | (a, _) <- g ]

lastSymbol :: [Symbol] -> Maybe Symbol
lastSymbol [] = Nothing
lastSymbol xs = Just (last xs)

fixpoint :: Eq a => (a -> a) -> a -> a
fixpoint f x
  | f x == x  = x
  | otherwise  = fixpoint f (f x)

rightEdges :: Grammar -> [(NT, NT)]
rightEdges g =
  [ (a, b) | (a, rhs) <- g
            , Just (N b) <- [lastSymbol rhs] ]

reachableFrom :: [(NT, NT)] -> NT -> [NT]
reachableFrom edges start = fixpoint expand initial
  where
    initial        = myNub [ b | (a, b) <- edges, a == start ]
    expand visited = myNub (visited ++ [ b | (a, b) <- edges, a `elem` visited ])

rightRecursive :: Grammar -> [NT]
rightRecursive g =
  [ a | a <- nonterminals g
      , a `elem` reachableFrom edges a ]
  where
    edges = rightEdges g


printResult :: String -> Grammar -> IO ()
printResult name g = do
  putStrLn $ "=== " ++ name ++ " ==="
  let rr     = rightRecursive g
  let allNTs = nonterminals g
  putStrLn $ "All nonterminals:    " ++ show allNTs
  putStrLn $ "Right-recursive:     " ++ show rr
  putStrLn $ "Not right-recursive: " ++ show [ a | a <- allNTs, a `notElem` rr ]
  putStrLn ""


g1 :: Grammar
g1 =
  [ ("S", [Te 'a', N "S"])
  , ("S", [Te 'a'])
  ]

g2 :: Grammar
g2 =
  [ ("S", [Te 'a', N "A"])
  , ("A", [Te 'b', N "A"])
  , ("A", [Te 'b'])
  ]

g3 :: Grammar
g3 =
  [ ("S", [Te 'a', N "B"])
  , ("B", [Te 'b'])
  ]

g4 :: Grammar
g4 =
  [ ("S", [N "S", Te 'a'])
  , ("A", [Te 'b', N "A"])
  , ("A", [Te 'b'])
  ]

g5 :: Grammar
g5 =
  [ ("A", [Te 'a', N "B"])
  , ("B", [Te 'b', N "C"])
  , ("C", [Te 'c', N "A"])
  ]


main :: IO ()
main = do
  printResult "Test 1: direct right-recursion (S -> a S)" g1
  printResult "Test 2: only A is right-recursive" g2
  printResult "Test 3: no right-recursive nonterminals" g3
  printResult "Test 4: left- and right-recursive together" g4
  printResult "Test 5: cycle A->B->C->A" g5
