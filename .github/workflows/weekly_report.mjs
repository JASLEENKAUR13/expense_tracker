const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const GROQ_API_KEY = process.env.GROQ_API_KEY;
const ONESIGNAL_APP_ID = process.env.ONESIGNAL_APP_ID;
const ONESIGNAL_REST_API_KEY = process.env.ONESIGNAL_REST_API_KEY;

const usersRes = await fetch(`${SUPABASE_URL}/rest/v1/profiles?select=id,user_name,onesignal_player_id`, {
  headers: {
    'apikey': SUPABASE_KEY,
    'Authorization': `Bearer ${SUPABASE_KEY}`
  }
});
const usersJson = await usersRes.json();
console.log('Supabase response:', JSON.stringify(usersJson));
const users = Array.isArray(usersJson) ? usersJson : [];
console.log(`Processing ${users.length} users`);

for (const user of users) {
  try {
    console.log(`Processing: ${user.user_name}`);

    const weekAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString();
    const expRes = await fetch(
      `${SUPABASE_URL}/rest/v1/expenses?user_id=eq.${user.user_id}&created_at=gte.${weekAgo}&select=*`,
      { headers: { 'apikey': SUPABASE_KEY, 'Authorization': `Bearer ${SUPABASE_KEY}` } }
    );
    const expenses = await expRes.json();
    console.log(`Found ${expenses.length} expenses`);

    if (expenses.length === 0) continue;

    const totalSpent = expenses.reduce((sum, e) => sum + parseFloat(e.amount || 0), 0);

    const groqRes = await fetch('https://api.groq.com/openai/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${GROQ_API_KEY}`
      },
      body: JSON.stringify({
        model: 'llama-3.3-70b-versatile',
        max_tokens: 4000,
        messages: [{
          role: 'user',
          content: `You are a personal finance analyst. Generate a beautiful HTML weekly expense report.
Category mapping: 1=Food, 2=Shopping, 3=Transport, 4=Salary, 5=Entertainment, 6=Other
Currency: Indian Rupees (₹)
Generate a single clean HTML page with:
1. Header with weekly report title and date range
2. Summary card: total spent, total transactions
3. Category breakdown table
4. Day wise spending table
5. Top 5 biggest expenses
6. AI insights: 2-3 smart observations
Use inline CSS only. Make it professional, clean and colorful.
Return ONLY the HTML. No explanation. No markdown. No backticks.
Total Spent: ₹${totalSpent}
Expense Count: ${expenses.length}
Expenses: ${JSON.stringify(expenses)}
Generate the full HTML report now.`
        }]
      })
    });

    const groqData = await groqRes.json();
    const htmlContent = groqData.choices?.[0]?.message?.content;
    if (!htmlContent) continue;

    await fetch(`${SUPABASE_URL}/rest/v1/reports?user_id=eq.${user.user_id}`, {
      method: 'DELETE',
      headers: { 'apikey': SUPABASE_KEY, 'Authorization': `Bearer ${SUPABASE_KEY}` }
    });

    const weekStart = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString().substring(0, 10);
    const weekEnd = new Date().toISOString().substring(0, 10);

    await fetch(`${SUPABASE_URL}/rest/v1/reports`, {
      method: 'POST',
      headers: {
        'apikey': SUPABASE_KEY,
        'Authorization': `Bearer ${SUPABASE_KEY}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        user_id: user.user_id,
        html_content: htmlContent,
        week_start: weekStart,
        week_end: weekEnd,
        is_read: false
      })
    });
    console.log(`Report saved for ${user.user_name}`);

    if (user.onesignal_player_id) {
      await fetch('https://onesignal.com/api/v1/notifications', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Basic ${ONESIGNAL_REST_API_KEY}`
        },
        body: JSON.stringify({
          app_id: ONESIGNAL_APP_ID,
          include_player_ids: [user.onesignal_player_id],
          headings: { en: "Weekly Report Ready 📊" },
          contents: { en: `Hey ${user.user_name?.split(' ')[0] || 'there'}! Your weekly expense report is ready.` }
        })
      });
      console.log(`Notification sent to ${user.user_name}`);
    }

  } catch (err) {
    console.error(`Error processing ${user.user_name}:`, err);
  }
}
console.log('All done!');
