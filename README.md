## Face Recognition
Face Comparision module
---
---
### Branch naming convention
-  Syntax: prefix-<story_jira_id>-<sub_task_jira_id>-<branch_name_separated_by_underscore>
-  Example: fnxt-2232-2234-branch_create
---
---
### Git Commit Message Convention  [Reference](https://docs.google.com/document/d/1QrDFcIiPjSLDn3EL15IJygNPiHORgU1_OOAqWjiDU5Y/edit#heading=h.7mqxm4jekyct)
- Syntax: ``<type>: <subject>. #FNXT-<story_jira_id>-<sub_task_jira_id>``
- Example: ``Added: Api to fetch list of bfis. #FNXT-2232-2234``
- Different ``<type>``
>-   ``Added`` :- for new features.
>-   ``Changed`` :- for changes in existing functionality.
>-   ``Deprecated`` :- for soon-to-be removed features.
>-   ``Removed`` :- for now removed features.
>-   ``Fixed`` :- for any bug fixes.
>-   ``Security`` :- in case of vulnerabilities.
---
---
### Guidline to run system
- On the base directory 
1. python -m pip install cmake
2. pip install -r requirements.txt
3. create .env file from env-sample
3. python copy_models.py
4. python manage.py runserver 0.0.0.0:``<port>``
- Example: ``python manage.py runserver 0.0.0.0:8000``

##### To Run celery:
- celery -A face_comparision worker -l info -c 8 --detach
