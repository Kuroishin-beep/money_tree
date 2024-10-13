
import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity;
import com.facebook.FacebookSdk;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Initialize Facebook SDK
        FacebookSdk.sdkInitialize(getApplicationContext());
    }
}
