#!/bin/bash

# Replace these placeholders with actual values
repository_name=$repository_name
specific_tag=$specific_tag
repository_uri=$repository_uri



# List all tags in the repository
tags_json=$(aws ecr list-images --repository-name $repository_name --output json)

# Check if the specific tag is present in the list of tags
tag_present=$(echo $tags_json | jq -r ".imageIds[] | select(.imageTag == \"$specific_tag\")" | jq -r .imageTag )
last_string_tag=$(echo $tag_present | rev | cut -d - -f 1 | rev)
if [ -n "$tag_present" ]; then
    # echo "Tag '$specific_tag' is present in the repository."
    if [ "$last_string_tag" = "snapshot" ]; then
        aws ecr batch-delete-image --repository-name $repository_name --image-ids imageTag=$specific_tag
        docker build -t $repository_uri:$specific_tag -f Dockerfile .
        docker push $repository_uri:$specific_tag
    else
        echo version already exists upgrade the version
        echo false
    fi
else
   docker build -t $repository_uri:$specific_tag -f Dockerfile .
   docker push $repository_uri:$specific_tag
fi
