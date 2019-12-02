package io.dcvz.rnzendesk;
import android.os.Bundle;
import zendesk.support.requestlist.RequestListActivity;


public class CustomRequestListActivity extends RequestListActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (this.getSupportActionBar() != null) {
            this.getSupportActionBar().setDisplayHomeAsUpEnabled(false);
            this.getSupportActionBar().setHomeButtonEnabled(false);
        }

        this.getSupportActionBar().setTitle("boom boom");
    }
}
