# cwl_workflows
Example CWL Workflows that run on the PIVOT architecture.

## How to run workflows

Data commons execution assumes you ae executing commands in the Data Commons Docker image.
```
$ ./bin/helium run base -cwl -U <username> -P <password>
```
The script `./bin/helium` is located [here](https://github.com/theferrit32/data-commons-workspace/blob/master/bin/helium).

### Touch Job

```
$ cd /renci/irods/home/chris_ball/my-tar-cwl/
$ cwltool --data-commons ../../../../../GitRepos/dc-cwl_workflows/workflows/complex-workflow/touch.cwl ../../../../../GitRepos/dc-cwl_workflows/workflows/complex-workflow/touch-job.yml
```
### Complex Workflow

Local execution:
```
$ cd workflows/complex-workflow/data
$ cwltool ../complex-workflow-1.cwl ../complex-workflow-1-job-local.yml
```

Will create `workflows/complex-workflow/data/test.tar` file with 8 files in the archive.

Data Commons execution:
```
$ cd /renci/irods/home/chris_ball/my-tar-cwl/
$ cwltool --data-commons /GitRepos/dc-cwl_workflows/workflows/complex-workflow/complex-workflow-1.cwl /GitRepos/dc-cwl_workflows/workflows/complex-workflow/complex-workflow-1-job-datacommons.yml
cwltool --data-commons ../../../../../GitRepos/dc-cwl_workflows/workflows/complex-workflow/complex-workflow-1.cwl ../../../../../GitRepos/dc-cwl_workflows/workflows/complex-workflow/complex-workflow-1-job-datacommons.yml
```
