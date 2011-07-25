module Main where
--
import HtmlToList
import Transformer.ListToIS
--
import System.Environment
import Data.ByteString.Lazy (putStrLn)
import Data.Aeson.Encode
import qualified Data.Map as M
--
import Transformer.TimeTableToJSONv2
--
import Transformer.IS
import Transformer.IsToEvent
--
import Transformer.Lecturer.MultiLecturer
--
import Transformer.Lecturer.ReadFHSLecturer
--
-- Web abfrage Module
import Network.HTTP.Enumerator
import Network.HTTP.Types
import qualified Data.ByteString.Lazy.UTF8 as BSLU
import Network.Socket
--
--
-- filePath = "../vorlage/s_bamm6.html"
--
-- iconv --from-code=ISO-8859-1 --to-code=UTF-8 s_bamm6.html > s_bamm6_unix.html
--
requestHTML addr = withSocketsDo $ do
    req0 <- parseUrl addr
    let req = req0 { method = methodGet }
    res <- withManager $ httpLbs req
    return $ BSLU.toString $ responseBody res
--
--
debug :: Bool
debug = True
--debug = False
--
-- :main "http://sund.de/steffen/plan/s_bai1.html"  -> geht
-- :main "http://sund.de/steffen/plan/s_bai2.html"  -> geht
--
-- :main "http://sund.de/steffen/plan/s_bai6.html"  -> geht
-- :main "http://sund.de/steffen/plan/s_bamm6.html" -> geht
--
--
--
main = do
   (filePath : args) <- getArgs
--   testTableByFile filePath
--   daten <- readFile filePath
   daten <- requestHTML filePath
   if debug == True 
    then
     print $ tableList daten
    else
     print ""
--   print "----------------------"
--
-- ^ Read Lecturer in Maps and apend it to one
   transDaten <- readMultiLecturer "test.txt"
   fhsLecturers <- readJSON "../daten/mongodb_bkp_fhsdozent.json"
--
   if debug == True
    then
     print $ convertListToIS $ tableList daten
---     print $ M.lookup "Mach" $ M.fromList $ (M.toList transDaten) ++ (M.toList fhsLecturers)
    else
     print ""
--
---   print $ convertListToIS $ tableList daten
--
-- eigentlicher aufruf um die tabellen daten zu verarbeiten
--   printTimeTable $ convertListToIS $ tableList daten
--
   Data.ByteString.Lazy.putStrLn $ encode $ 
           convertISToEventS ( convertListToIS $ tableList daten ) 
                             2 
                             (M.fromList $ (M.toList transDaten) ++ (M.toList fhsLecturers))
                             ("2009-06-24 12:00:00","2009-06-24 13:30:00")
                             "2009-06-24 12:00:00"
--
-- | The readMultiLecturer function is for Lecturer combinations.
-- For example ChanHoel is a combination about Chantelau and Höller
testReadMultiLecturer = do
--   print "hallo"
   transDaten <- readMultiLecturer "test.txt"
   print $ M.lookup "Mach" transDaten
--
-- | This is a example for using the readJSON function.
-- The existens reason is that the JSON file have to many informations.
-- The readJSON function minimize the informations to a MAP.
testReadFHSLecturers = do
   fhsLecturers <- readJSON "../daten/mongodb_bkp_fhsdozent.json"
   print $ M.lookup "Recknagel" fhsLecturers
--
{-
testConverterIsEv = do
--   print lecture
   Data.ByteString.Lazy.putStrLn $ encode $ convertISToEventS [lecture] 
                             2 
                             ["Braun","Knolle","Stiefel"] 
                             ("2009-06-24 12:00:00","2009-06-24 13:30:00") 
                             "2009-06-24 12:00:00"
  where 
   lecture = Lecture {day="Montag", timeSlot=TimeSlot{tstart=TimeStamp{houre="12",minute="00"},tend=TimeStamp{houre="13",minute="30"}}, vtype="Vorlesung", vname="GrInfv", location=Location{building="F",room="111"}, week="w", group="", lecturer="braun"}
-}
--
