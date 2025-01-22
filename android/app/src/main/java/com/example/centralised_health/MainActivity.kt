import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.nityamgandhi.centralised_health.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // Use binding to access views
        binding.textView.text = "Hello, World!"
    }
}