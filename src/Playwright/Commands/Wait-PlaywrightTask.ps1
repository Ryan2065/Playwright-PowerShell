Function Wait-PlaywrightTask{
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Threading.Tasks.Task]$Task
    )
    return $Task.GetAwaiter().GetResult()
}