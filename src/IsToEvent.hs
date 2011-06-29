module IsToEvent where
--
--
import IS
import EventS
--
--
--import Data.Aeson
--import Data.Aeson.Types ( parseMaybe )
---import Data.Attoparsec.Lazy hiding ( take, takeWhile )
--import Control.Applicative ( (<$>), (<*>), pure )
--import Data.ByteString.Lazy (ByteString, putStrLn, writeFile)
--
--import TimeTableToJSONv2
--
--
-- TODO: es muss die class_id noch abgefragt werden, damit die daten richtig eingefuegt werden koennen
--
--
convertISToEventS :: TimeTable -> Int -> [String] -> (String,String) -> String -> Events
convertISToEventS [] _ _ _ _ = []
convertISToEventS (lecture : timeTable) classID fhsIDs eventStamp expire = 
      (Event { titleShort  = vname lecture
             , titleLong   = readTitleLong $ vname lecture
             , expireDate  = expire
             , eventType   = transformVType $ vtype lecture
             , degreeClass = [DegreeClass {class_id=classID}]
--             , member      = Member $ generateMember fhsIDs
             , member      = generateMember fhsIDs
             , appointment = generateAppointment eventStamp (IS.location lecture) (week lecture)
             }
      ) : (convertISToEventS timeTable classID fhsIDs eventStamp expire)
--
--
transformVType :: String -> String
transformVType "Vorlesung" = "Lecture"
transformVType "Uebung"    = ""
transformVType ""          = "Nothing"
--
--
-- ein generator um alle appointments zu generieren
generateAppointment :: (String,String) -> IS.Location -> String -> [Appointment]
generateAppointment (startEvent,endEvent) location week = []
--
--
--generateMember :: [String] -> [Member]
generateMember [] = []
generateMember (fhsID : fhsIDs) = 
--       (fhs_id=fhsID) : (generateMember fhsIDs)
       (FhsID {fhs_id=fhsID}) : (generateMember fhsIDs)
--       (memb) : (generateMember fhsIDs)
--
--    where 
--     memb = case (Member {fhs_id=fhsID}) of 
--              Member x -> x
--
-- | This function is for the name resolution.
-- The first parameter is the short name and the output is the long name
-- of a lecture.
readTitleLong :: String -> String
readTitleLong "GrInfv" = "Grundlagen Informationsverarbeitung"
readTitleLong titleShort = []
--
--
--
