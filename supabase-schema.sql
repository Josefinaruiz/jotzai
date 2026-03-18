-- JotzAI — Supabase Schema
-- Run this in the Supabase SQL editor

-- Companies table
CREATE TABLE IF NOT EXISTS companies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  website TEXT,
  industry TEXT,
  account_type TEXT CHECK (account_type IN ('Active Client', 'Inactive Client', 'Open Pipeline', 'Standby', 'Lost')) DEFAULT 'Open Pipeline',
  crm_stage TEXT,
  last_contact DATE,
  open_deals INTEGER DEFAULT 0,
  revenue TEXT,
  copper_id TEXT UNIQUE,
  description TEXT,
  logo_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Contacts table
CREATE TABLE IF NOT EXISTS contacts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  email TEXT,
  title TEXT,
  phone TEXT,
  copper_id TEXT UNIQUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Alerts table
CREATE TABLE IF NOT EXISTS alerts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
  type TEXT CHECK (type IN ('funding', 'news', 'hiring', 'product_launch', 'leadership', 'award')) NOT NULL,
  priority TEXT CHECK (priority IN ('high', 'medium', 'low')) DEFAULT 'medium',
  title TEXT NOT NULL,
  summary TEXT NOT NULL,
  source_url TEXT,
  source_name TEXT,
  ai_suggestion TEXT,
  draft_message TEXT,
  status TEXT CHECK (status IN ('new', 'contacted', 'snoozed', 'shared', 'dismissed')) DEFAULT 'new',
  snoozed_until TIMESTAMPTZ,
  published_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE contacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE alerts ENABLE ROW LEVEL SECURITY;

-- Allow public read/write for anon (adjust as needed)
CREATE POLICY "Public access companies" ON companies FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Public access contacts" ON contacts FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Public access alerts" ON alerts FOR ALL USING (true) WITH CHECK (true);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_alerts_company ON alerts(company_id);
CREATE INDEX IF NOT EXISTS idx_alerts_status ON alerts(status);
CREATE INDEX IF NOT EXISTS idx_alerts_type ON alerts(type);
CREATE INDEX IF NOT EXISTS idx_contacts_company ON contacts(company_id);
CREATE INDEX IF NOT EXISTS idx_companies_account_type ON companies(account_type);
