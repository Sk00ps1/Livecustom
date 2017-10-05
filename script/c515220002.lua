--Meklord Army of Asterisk
function c515220002.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(515220002,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,515220002)
	e1:SetCost(c515220002.eqcost)
	e1:SetTarget(c515220002.eqtg)
	e1:SetOperation(c515220002.eqop)
	c:RegisterEffect(e1)	
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(515220002,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,515220003)
	e2:SetCondition(c515220002.thcon)
	e2:SetTarget(c515220002.thtg)
	e2:SetOperation(c515220002.thop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(515220000,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,515220004)
	e3:SetCondition(c515220002.thcon2)
	e3:SetTarget(c515220002.thtg2)
	e3:SetOperation(c515220002.thop2)
	c:RegisterEffect(e3)
end
function c515220002.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c515220002.filter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsAbleToChangeControler() 
		and Duel.IsExistingMatchingCard(c515220002.eqfilter,tp,LOCATION_MZONE,0,1,nil,c,tp)
end
function c515220002.eqfilter(c,ec,tp)
	local eff={c:GetCardEffect(100407001)}
	if c:IsFacedown() or ((not c:IsSetCard(0x3013)) and not c:IsType(TYPE_MONSTER)) then return false end
	for _,te in ipairs(eff) do
		if te:GetValue()(ec,c,tp) then return true end
	end
	return false
end
function c515220002.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c515220002.filter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c515220002.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c515220002.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c515220002.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFirstTarget()
	if not tc1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c515220002.eqfilter,tp,LOCATION_MZONE,0,1,1,nil,tc1,tp)
	local tc2=g:GetFirst()
	if not tc2 then return end
	local te=tc2:GetCardEffect(100407001)
	if tc1:IsFaceup() and tc1:IsRelateToEffect(e) and tc1:IsControler(1-tp) then
		te:GetOperation()(tc2,te:GetLabelObject(),tp,tc1)
	end
end
function c515220002.thfilter(c,e)
	return c:IsType(TYPE_SYNCHRO)
end
function c515220002.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c515220002.thfilter,1,nil)
end
function c515220002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c515220002.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
function c515220002.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c515220002.thfilter2(c)
	return c:IsSetCard(0x13) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c515220002.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c515220002.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c515220002.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c515220002.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
