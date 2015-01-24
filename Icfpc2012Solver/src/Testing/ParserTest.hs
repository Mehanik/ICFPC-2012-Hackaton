module Testing.ParserTest where

import Common
import LabyrinthParser.Parser
import Data.Either
import Data.Either.Unwrap

import Control.Monad (liftM)

getTestName tName n = tName ++ ", " ++ takeWhile (/= '.') n

testPadding (src, expected) = do
    d <- loadTestData src
    e <- liftM lines $ loadTestData expected
    let result = fromRows d
    if (result == e) then putStrLn $ "passed: " ++ (getTestName "testPadding" src) ++ "."
                     else putStrLn $ "FAILED! " ++ (getTestName "testPadding" src) ++ ". Expected:\n" ++ show e ++ "\nResult:\n" ++ show result

testParsing (src, expected) = do
    d <- loadTestData src
    let result = parse d
    putStrLn $ (if ((isRight result && expected) || (isLeft result && not expected)) then "passed: " else "FAILED! ")
             ++ getTestName "testPadding" src ++ ", result: " ++
        case result of
            Right _ -> "parsed successfully."
            Left msg -> "not parsed. Message: " ++ msg
    
test :: IO ()
test = do

    testPadding ("OneLine.txt", "OneLine.txt")
    testPadding ("TwoLines.txt", "TwoLines.txt")
    testPadding ("TwoNonPaddedLines.txt", "TwoNonPaddedLines_expected.txt")
    
    testParsing ("OneLine.txt", True)
    testParsing ("TwoLines.txt", True)
    testParsing ("TwoNonPaddedLines.txt", True)
    testParsing ("NoRobot.txt", False)
    testParsing ("NoLift.txt", False)
    testParsing ("2Robots.txt", False)
    testParsing ("2Lifts.txt", False)
    
