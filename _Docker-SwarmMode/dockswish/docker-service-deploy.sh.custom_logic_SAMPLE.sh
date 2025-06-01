echo "#### CUSTOM LOGIC START #################################################################"
echo "Applying custom logic for PRJ_TYPE:${PRJ_TYPE} PRJ_NAME:${PRJ_NAME}"

  case ${PRJ_TYPE} in

    "custom")
      TARGET_SERVERS="b5" # tracker botlari b4|b5'te calismali
    ;;
   
    *)
      case ${PRJ_NAME} in ## => PRJ_FULLNAME
        "main")
          TARGET_SERVERS="b0"
        ;;
        "auxilary")
          TARGET_SERVERS="b1 b2"
        ;;
        *)
          TARGET_SERVERS="b0 b1 b2 b3" 
        ;;
      esac
    ;;
  esac

echo "Selected TARGET_SERVERS:${TARGET_SERVERS}"
echo "#### CUSTOM LOGIC END   #################################################################"
