{- 
21. Виявити, чи допускає скінчений автомат хоча б одне слово, 
яке складається з однакових символів. 
При ствердній відповіді навести приклад відповідного слова.
-}

data FA = FA
  { states   :: [String]
  , alphabet :: [Char]
  , delta    :: [(String, Char, String)]
  , startSt  :: String
  , finalSts :: [String]
  }


step :: FA -> String -> Char -> [String]
step fa st c = [q' | (q, a, q') <- delta fa, q == st, a == c]


accepts :: FA -> String -> Bool
accepts fa word = go (startSt fa) word
  where
    go q []     = q `elem` finalSts fa
    go q (c:cs) = any (\q' -> go q' cs) (step fa q c)


task21 :: FA -> Maybe String
task21 fa = firstJust [ tryChar c | c <- alphabet fa ]
  where
    maxLen = 2 * length (states fa)

    tryChar c = firstJust
      [ if accepts fa word then Just word else Nothing
      | n <- [1..maxLen]              
      , let word = replicate n c
      ]

    firstJust []           = Nothing
    firstJust (Nothing:xs) = firstJust xs
    firstJust (Just x :_ ) = Just x


runTask21 :: String -> FA -> IO ()
runTask21 name fa = do
  putStrLn $ "=== " ++ name ++ " ==="
  case task21 fa of
    Nothing   -> putStrLn "No word with identical symbols."
    Just word -> putStrLn $ "Yes! Example: \"" ++ word ++ "\""
  putStrLn ""



fa1 = FA ["q0","q1","q2","q3"] "ab"
        [("q0",'a',"q1"),("q1",'a',"q2"),("q2",'a',"q3")]
        "q0" ["q3"]

fa2 = FA ["q0","q1"] "ab"
        [("q0",'a',"q1"),("q1",'a',"q0")]
        "q0" ["q0"]



fa3 = FA ["q0","q1","q2"] "ab"
        [("q0",'b',"q1"),("q1",'a',"q1"),
         ("q1",'b',"q2"),("q2",'b',"q2")]
        "q0" ["q2"]



fa4 = FA ["q0","q1","q2"] "ab"
        [("q0",'a',"q1"),("q1",'b',"q2"),
         ("q2",'a',"q1")]
        "q0" ["q2"]


main :: IO ()
main = do
  runTask21 "Test 1: accepts exactly \"aaa\"" fa1
  runTask21 "Test 2: accepts words with even number of a" fa2
  runTask21 "Test 3: accepts words starting and ending with b" fa3
  runTask21 "Test 4: accepts repetitions of \"ab\"" fa4
