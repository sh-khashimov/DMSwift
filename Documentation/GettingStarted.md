# Getting Started

APIs and features overview:

- **Downloader** : [Download a single file](#download-single-file) ‣ [Download files](#donwload-files)
- **Events Handler** : [Delegate](#delegate) ‣ [Callbacks](#callbacks)
- **Post-processing** : [Adding post-process](#adding-post-process) ‣ [Poss-process Delegate](#http-disk-cache) ‣ [Post-process Callbacks](#post-process-callback) ‣ [Creating Post-process](#creating-post-process)
- **Advanced Features** : [Configurations](#configurations) ‣ [File Storage](#image-preheating)

# Downloader

### Download a single file

```swift
// 1. Create a DMSwift instance with the cache directory path
let downloadManager = DMSwift(path: "features/content")
// 2. Start download a file
downloadManager.download(url) { fileData in
		guard fileData.error == nil, path = fileData.location?.path else { return }
		print("file location path: \(path)")
	}
```

### Download files

```swift
// 1. Create a DMSwift instance with the cache directory path
let downloadManager = DMSwift(path: "features/content")
// 2. Use callbacks
downloadManager.onDownloadComplete = { [weak self] in
		self?.showDownloadSuccessAlert()
	}
downloadManager.onDownloadCompletedWithError = { [weak self] failedTasks in
       print("failed to download tasks: \(failedTasks)")
	}
// 3. Start downloads
downloadManager.download(urls)
```

> See [Events Handler](#events-handler) to learn more about available delegates and callbacks.

# Events Handler

To handler events, you can use a delegate or callbacks. 

### Delegate

Use *`downloadProgressDelegate`* to receive events related to downloads. 

To use a delegate:

```swift
class ViewController: UIViewController {
	// .zip files location directory path
	private var zipDirectory: String = "content/zip"
	// Download Manager
	private lazy var zipDownloadManager: DMSwift = {
        let downloadManager = DMSwift(path: zipDirectory)
		 // Set downloadProgressDelegate to self to start use a delegate
        downloadManager.downloadProgressDelegate = self
        return downloadManager
    }()
}

extension ViewController: DownloaderProgressDelegate {
…
}
```
Informs when download operations started.
``` Swift
func downloadStarted()
```
Informs when all download operations finished successfully.
``` Swift
func downloadDidComplete()
```
Informs when downloaded operations finished and some of them have errors.
``` Swift
func downloadDidCompletedWithError(tasks: [DMSwiftTypealias.Download.FailedTask])
```
Informs when downloaded size or total files size changes.
``` Swift
func downloadDidUpdate(progress: Float, downloadedSize: Int64, totalSize: Int64)
```
Informs on changes in download task count progress.
``` Swift
func downloadDidUpdate(progress: Float, finishedTaskCount: Int64, taskCount: Int64)
```

### Callbacks

Using *`completion`* callback at `download` method, when downloading a single file:

```swift
downloadManager.download(url) { fileData in
	guard fileData.error == nil, path = fileData.location?.path else { return }
	print("file location path: \\(path)")
}
```

> *`completion`* handler at `download` method called when one of the download operations is finish in the queue.

Using *`onDownloadComplete`* callback:

``` swift
// called when all downloads complete successfully in the queue
downloadManager.onDownloadComplete = { [weak self] in
	print("download completed")
}
```

Using *`onDownloadCompletedWithError`* callback:

``` swift
// called when all downloads complete in the queue, but some of them finished with error.
downloadManager.onDownloadCompletedWithError = { [weak self]  failedTasks in
	print("failed to download tasks: \(failedTasks)")
}
```

Using *`onDownloadStarted`* callback:

``` swift
// Used to inform that one of the downloads started in queue.
downloadManager.onDownloadStarted = { [weak self] in
    print("download started")
}
```

Using *`onDownloadUpdateTaskCount`* callback:

``` swift
// Informs on changes in download task count progress.
downloadManager.onDownloadUpdateTaskCount = { [weak self]  taskProgress in
	print(“task progress percent: \(taskProgress.progress*100)%”)
}
```

Using *`onDownloadUpdateSize`* callback:

``` swift
// Informs when downloaded size or total files size changes.
downloadManager.onDownloadUpdateSize = { [weak self]  sizeProgress in
	print(“task progress percent: \(sizeProgress.progress*100)%”)
}
```
<br/>

# Post-processing

DMSwift allows you to add post-processing to downloaded files. For example, using [**`DMSwiftZipPostProcessing `**](https://github.com/sh-khashimov/DMSwiftZipPostProcessing), you can unzip a .zip file after the file is downloaded.

An example:

```swift
// creates a .zip processing
let zipProcessing = DMSwiftZipPostProcessing()
// creates download manager with post-process
let downloadManager = DMSwift(path: directory, postProcessings: [zipProcessing])
// start downloads
downloadManager.download([zipFileURLs])
```

> **`DMSwift`** doesn’t include *`DMSwiftZipPostProcessing `* or other post-processes, however, it’s possible to create own post-process or use one of the [available](/Available_PostProcesses.md). See [how post-process works](/PostProcessing.md) to learn more.

### Poss-process Delegate

An example, how to start using delegate for post-processing:

```swift
// create download manager
…
// set delegate
downloadManager.postProcessDelegate = self

// uses post-process delegate methods
extension ViewController: PostProcessDelegate {
…
}
```
Informs when post-processing operations started.
``` Swift
func postProcessStarted()
```
Informs when all post-processing operations finished successfully.
``` Swift
func postProcessDidComplete()
```
Informs when post-processing operations finished and some of them have errors.
``` Swift
func postProcessDidCompletedWithError(tasks: [DMSwiftTypealias.PostProcess.FailedTask])
```
Informs on changes in post-process operations count progress.
``` Swift
func postProcessDidUpdate(progress: Float, finishedTaskCount: Int64, taskCount: Int64)
```

### Post-process Callbacks

Using *`onPostProcessStarted`* callback:

``` swift
// Used to inform that one of the post-processes started in queue.
downloadManager.onPostProcessStarted = { [weak self] in
    print(“post-process started")
}
```

Using *`onPostProcessCompleted`* callback:

``` swift
// called when all post-processes complete successfully in the queue.
downloadManager.onPostProcessCompleted = { [weak self] in
	print(“post processes completed")
}
```

Using *`onProcessCompletedWithError`* callback:

``` swift
// called when all post-processes complete in the queue, but some of them finished with error.
downloadManager.onProcessCompletedWithError = { [weak self]  postProcessFailedTask in
	print("failed to post-process tasks: \(postProcessFailedTask)")
}
```

Using *`onPostProcessUpdateTaskCount`* callback:

``` swift
// Reports on changes in post-process task count progress.
downloadManager.onPostProcessUpdateTaskCount = { [weak self]  taskProgress in
	print(“task progress percent: \(taskProgress.progress*100)%”)
}
```

### Creating Post-process

Use **`PostProcessing`** protocol to create your own post-process for downloaded files.

> See [how post-process works](/PostProcessing.md) to learn more.

> See [available post-process](/Available_PostProcesses.md) to learn more.

<br/>

# Advanced Features 

### Configurations

You can modify the **`DMSwift`** configuration directly changing the *`configuration`* parameters or create your own configuration inheriting from the **`DMSwiftConfiguration`** `protocol` and assign your created configuration during initialization or through the update method.

Consider the following example:

``` swift
// initializes DMSwift
let downloadManager = DMSwift(path: directoryPath)
// Updates max concurrent downloads count
let downloadManager.configuration.downloadMaxConcurrentOperationCount = 10
```

The configuration makes it possible to configure parameters such as *maximum download operations that should start concurrently*, *download queue QoS type*, *type of session task*, and so on.

> See *`DMSwiftConfiguration`* at <a href="https://sh-khashimov.github.io/DMSwift/" target="_blank">API documentaion</a> to learn more.

> See [DMSwift in-depth](/DMSwift_inDepth.md) to learn more about how different configurations can effect to work.


### File Storage

If you need access to files, you can use the **`FileStorage`**. All methods are `Public` for use.

> See *`FileReading`*, *`FileWriting`* `protocols` <a href="https://sh-khashimov.github.io/DMSwift/" target="_blank">API documentaion</a> for more info.

<br/>