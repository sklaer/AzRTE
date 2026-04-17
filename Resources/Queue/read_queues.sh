touch queues_res.txt
cat queues.json| jq '.[] | .name' | cut -f 2 -d '"' | while read i; do
    az storage message peek --account-name queuelab102fedb58 --auth-mode login --queue-name $i >> queues_res.txt
done

cat queues_res.txt | grep content | grep -v "looking" 