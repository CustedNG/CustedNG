package cc.xuty.custed2

import com.fasterxml.jackson.databind.ObjectMapper
import okhttp3.OkHttpClient
import java.util.concurrent.Executors

object Shared {
    val okHttpClient by lazy { OkHttpClient() }
    val executor by lazy { Executors.newCachedThreadPool() }
    val objectMapper by lazy { ObjectMapper() }
}