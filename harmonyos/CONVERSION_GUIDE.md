# HBox Android to HarmonyOS Next Conversion Guide

This document outlines the conversion process from Android to HarmonyOS Next and serves as a reference for developers working on this project.

## Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Key Conversions](#key-conversions)
3. [Framework Differences](#framework-differences)
4. [Best Practices](#best-practices)
5. [Troubleshooting](#troubleshooting)

## Architecture Overview

### Android Architecture
```
Android Application
├── Activities (UI Pages)
├── Fragments (UI Components)
├── ViewModels (Business Logic)
├── Room Database (Persistence)
├── OkHttp (Networking)
├── ExoPlayer/IJK (Video)
└── EventBus (Communication)
```

### HarmonyOS Architecture
```
HarmonyOS Application
├── Pages (UI Pages)
├── Components (UI Components)
├── ViewModels (Business Logic)
├── RelationalStore (Persistence)
├── HTTP Module (Networking)
├── AVPlayer (Video)
└── EventHub (Communication)
```

## Key Conversions

### 1. UI Layer

#### Activity → Page
**Android:**
```java
public class HomeActivity extends BaseActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);
    }
}
```

**HarmonyOS:**
```typescript
@Entry
@Component
struct HomePage {
  aboutToAppear() {
    // Initialization logic
  }

  build() {
    Column() {
      // UI components
    }
  }
}
```

#### Fragment → Component
**Android:**
```java
public class GridFragment extends BaseLazyFragment {
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_grid, container, false);
    }
}
```

**HarmonyOS:**
```typescript
@Component
struct GridComponent {
  build() {
    Grid() {
      // Grid items
    }
  }
}
```

#### RecyclerView → List/Grid
**Android:**
```java
RecyclerView recyclerView = findViewById(R.id.recyclerView);
recyclerView.setLayoutManager(new GridLayoutManager(this, 5));
recyclerView.setAdapter(new GridAdapter(data));
```

**HarmonyOS:**
```typescript
Grid() {
  ForEach(this.dataList, (item) => {
    GridItem() {
      // Item content
    }
  })
}
.columnsTemplate('1fr 1fr 1fr 1fr 1fr')
```

### 2. Navigation

#### Intent → Router
**Android:**
```java
Intent intent = new Intent(this, DetailActivity.class);
intent.putExtra("videoId", videoId);
startActivity(intent);
```

**HarmonyOS:**
```typescript
router.pushUrl({
  url: 'pages/DetailPage',
  params: {
    videoId: videoId
  }
});
```

### 3. Data Persistence

#### Room Database → RelationalStore
**Android:**
```java
@Dao
public interface VodRecordDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    void insert(VodRecord record);

    @Query("SELECT * FROM VodRecord ORDER BY updateTime DESC")
    List<VodRecord> getAllRecords();
}
```

**HarmonyOS:**
```typescript
class DatabaseManager {
  async saveVodRecord(vodId: string, sourceKey: string, dataJson: string): Promise<void> {
    const valueBucket: relationalStore.ValuesBucket = {
      'vodId': vodId,
      'sourceKey': sourceKey,
      'updateTime': Date.now(),
      'dataJson': dataJson
    };
    await this.store.insert('VodRecord', valueBucket, ConflictResolution.ON_CONFLICT_REPLACE);
  }

  async getVodRecordList(): Promise<VodRecord[]> {
    const predicates = new relationalStore.RdbPredicates('VodRecord');
    predicates.orderByDesc('updateTime');
    const resultSet = await this.store.query(predicates);
    // Process result set
  }
}
```

#### SharedPreferences → Preferences
**Android:**
```java
SharedPreferences prefs = getSharedPreferences("app_prefs", MODE_PRIVATE);
prefs.edit().putString("api_url", url).apply();
String apiUrl = prefs.getString("api_url", "");
```

**HarmonyOS:**
```typescript
await PreferenceManager.getInstance().putString('api_url', url);
const apiUrl = await PreferenceManager.getInstance().getString('api_url');
```

### 4. Networking

#### OkHttp → HTTP Module
**Android:**
```java
OkHttpClient client = new OkHttpClient();
Request request = new Request.Builder()
    .url(url)
    .build();
Response response = client.newCall(request).execute();
String result = response.body().string();
```

**HarmonyOS:**
```typescript
const result = await HttpClient.getInstance().get(url);
```

### 5. Video Playback

#### ExoPlayer/IJK → AVPlayer
**Android:**
```java
SimpleExoPlayer player = new SimpleExoPlayer.Builder(context).build();
playerView.setPlayer(player);
MediaItem mediaItem = MediaItem.fromUri(videoUrl);
player.setMediaItem(mediaItem);
player.prepare();
player.play();
```

**HarmonyOS:**
```typescript
this.avPlayer = await media.createAVPlayer();

this.avPlayer.on('stateChange', (state) => {
  // Handle state changes
});

this.avPlayer.url = videoUrl;
await this.avPlayer.play();
```

### 6. Lifecycle Methods

| Android | HarmonyOS | Description |
|---------|-----------|-------------|
| `onCreate()` | `aboutToAppear()` | Component initialization |
| `onStart()` | `aboutToAppear()` | Component about to appear |
| `onResume()` | `onPageShow()` | Page shown |
| `onPause()` | `onPageHide()` | Page hidden |
| `onStop()` | - | No direct equivalent |
| `onDestroy()` | `aboutToDisappear()` | Component cleanup |

## Framework Differences

### State Management

**Android (ViewModel + LiveData):**
```java
public class SourceViewModel extends ViewModel {
    private MutableLiveData<List<Video>> videoList = new MutableLiveData<>();

    public LiveData<List<Video>> getVideoList() {
        return videoList;
    }

    public void loadVideos() {
        // Load data
        videoList.setValue(videos);
    }
}
```

**HarmonyOS (@State):**
```typescript
@Component
struct HomePage {
  @State videoList: Video[] = [];

  loadVideos() {
    // Load data
    this.videoList = videos; // Automatically triggers UI update
  }
}
```

### Event Communication

**Android (EventBus):**
```java
// Post event
EventBus.getDefault().post(new RefreshEvent());

// Subscribe
@Subscribe(threadMode = ThreadMode.MAIN)
public void onRefreshEvent(RefreshEvent event) {
    // Handle event
}
```

**HarmonyOS (EventHub):**
```typescript
// Emit event
getContext().eventHub.emit('refresh', data);

// Subscribe
getContext().eventHub.on('refresh', (data) => {
  // Handle event
});
```

### Permissions

**Android (Manifest):**
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

**HarmonyOS (module.json5):**
```json
"requestPermissions": [
  {
    "name": "ohos.permission.INTERNET"
  }
]
```

## Best Practices

### 1. Use @State for Reactive UI
Always use `@State` for data that should trigger UI updates:
```typescript
@State isLoading: boolean = true;
@State dataList: Item[] = [];
```

### 2. Prefer Async/Await
Use async/await for asynchronous operations:
```typescript
async loadData() {
  try {
    const result = await HttpClient.getInstance().get(url);
    this.dataList = JSON.parse(result);
  } catch (err) {
    console.error(`Failed to load: ${JSON.stringify(err)}`);
  }
}
```

### 3. Resource Management
Always release resources in `aboutToDisappear()`:
```typescript
aboutToDisappear() {
  if (this.avPlayer) {
    this.avPlayer.release();
  }
  if (this.timer !== -1) {
    clearInterval(this.timer);
  }
}
```

### 4. Error Handling
Always handle errors properly:
```typescript
try {
  await operation();
} catch (err) {
  console.error(`Operation failed: ${JSON.stringify(err)}`);
  // Show error to user
}
```

### 5. Type Safety
Use TypeScript interfaces for type safety:
```typescript
interface VideoItem {
  id: string;
  name: string;
  pic: string;
}

@State videos: VideoItem[] = [];
```

## Troubleshooting

### Common Issues

#### 1. XComponent Not Showing Video
**Problem**: Video surface not displaying
**Solution**: Ensure XComponent has valid dimensions and the AVPlayer is properly initialized

#### 2. Database Operations Failing
**Problem**: RelationalStore operations return null
**Solution**: Check if DatabaseManager is properly initialized in EntryAbility

#### 3. Navigation Not Working
**Problem**: Router.pushUrl() does nothing
**Solution**: Verify page path in main_pages.json

#### 4. State Not Updating UI
**Problem**: UI doesn't refresh when data changes
**Solution**: Ensure you're using `@State` decorator and assigning values correctly

#### 5. Permission Denied Errors
**Problem**: Network or file operations fail
**Solution**: Check permissions in module.json5 and request runtime permissions if needed

### Performance Optimization

1. **Lazy Loading**: Use ForEach with item keys for efficient list rendering
2. **Image Caching**: Implement image caching for better performance
3. **Database Indexing**: Add indices to frequently queried columns
4. **Network Caching**: Cache API responses when appropriate
5. **Component Reuse**: Use `@Reusable` for frequently created components

## Next Steps

1. Test on real HarmonyOS devices
2. Implement missing features from Android version
3. Optimize performance and memory usage
4. Add comprehensive error handling
5. Implement unit and integration tests
6. Add localization support
7. Document API contracts

## Resources

- [HarmonyOS Next Documentation](https://developer.harmonyos.com/)
- [ArkTS Language Guide](https://developer.harmonyos.com/en/docs/documentation/doc-guides-V3/arkts-get-started-0000001504769321-V3)
- [ArkUI Framework](https://developer.harmonyos.com/en/docs/documentation/doc-guides-V3/arkui-overview-0000001502351932-V3)
- [Original HBox Android Project](https://github.com/Tangsan99999/HBox)

---

**Last Updated**: 2026-01-09
**Version**: 1.0.0
