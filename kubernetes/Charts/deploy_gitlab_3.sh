#!/bin/bash
 
## Сгенерируем структуру каталогов в рамках выполнения дз и запушим в проект
 
DIR=(
	'comment'
	'post'
	'ui'
	'reddit-deploy'
)

cd ..
 
for dir in "${DIR[@]}"
do

	mkdir -p Gitlab_ci/${dir}
	
	if [[ "$dir" == "post" ]]; then
		cp -r ../src/${dir}-py/* Gitlab_ci/${dir}/
	elif [[ "$dir" == "reddit-deploy" ]]; then
		cp -r ./Charts/comment Gitlab_ci/${dir}/
		cp -r ./Charts/post Gitlab_ci/${dir}/
		cp -r ./Charts/reddit Gitlab_ci/${dir}/
		cp -r ./Charts/ui Gitlab_ci/${dir}/
	else
		cp -r ../src/${dir} Gitlab_ci/
	fi
	
	rm -rf Gitlab_ci/${dir}/.git
	
	cd Gitlab_ci/${dir}
	
	git init
	
#	if [[ "$dir" == "comment" ]] || [[ "$dir" == "post" ]] || [[ "$dir" == "ui" ]]; then
	if [[ "$dir" != "reddit-deploy" ]]; then
		curl https://raw.githubusercontent.com/express42/otus-snippets/master/kubernetes-4/ui/gitlab-ci-1.yml --insecure > .gitlab-ci.yaml
	fi
		
	git remote add origin http://gitlab.otus.local/geralex88/${dir}.git
	
	git add .
	git commit -m "Init"
	git push origin master
	
	cd ../..
 
done
