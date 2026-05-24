const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const ONESIGNAL_APP_ID = process.env.ONESIGNAL_APP_ID;
const ONESIGNAL_REST_API_KEY = process.env.ONESIGNAL_REST_API_KEY;

// Get current IST time
const now = new Date();
const istOffset = 5.5 * 60 * 60 * 1000;
const istTime = new Date(now.getTime() + istOffset);
const currentHour = istTime.getUTCHours().toString().padStart(2, '0');
const currentMin = istTime.getUTCMinutes().toString().padStart(2, '0');
const currentTime = `${currentHour}:${currentMin}:00`;

console.log(`Running for IST time: ${currentTime}`);

const res = await fetch(
  `${SUPABASE_URL}/rest/v1/profiles?reminder_time=eq.${currentTime}&select=id,user_name,onesignal_player_id`,
  {
    headers: {
      'apikey': SUPABASE_KEY,
      'Authorization': `Bearer ${SUPABASE_KEY}`
    }
  }
);

const usersJson = await res.json();
const users = Array.isArray(usersJson) ? usersJson : [];
console.log(`Found ${users.length} users to remind`);

for (const user of users) {
  if (!user.onesignal_player_id) {
    console.log(`Skipping ${user.user_name} - no onesignal id`);
    continue;
  }

  const notifRes = await fetch('https://onesignal.com/api/v1/notifications', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Basic ${ONESIGNAL_REST_API_KEY}`
    },
    body: JSON.stringify({
      app_id: ONESIGNAL_APP_ID,
      include_player_ids: [user.onesignal_player_id],
      headings: { en: "Expenso 💰" },
      contents: { en: `Hey ${user.user_name?.split(' ')[0] || 'there'}! Don't forget to log your expenses today.` }
    })
  });

  const notifData = await notifRes.json();
  console.log(`Sent to ${user.user_name}:`, JSON.stringify(notifData));
}

console.log('All done!');
