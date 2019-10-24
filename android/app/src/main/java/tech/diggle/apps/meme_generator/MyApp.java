package tech.diggle.apps.meme_generator;

import android.content.Context;

import io.flutter.app.FlutterApplication;
import androidx.multidex.MultiDex;

public class MyApp extends FlutterApplication {
    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(this);
    }
}
