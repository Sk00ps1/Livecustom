--Meklord Mobilization
function c515220005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,515220005+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c515220005.target)
	e1:SetOperation(c515220005.activate)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(515220005,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c515220005.eqcost)
	e2:SetTarget(c515220005.eqtg)
	e2:SetOperation(c515220005.eqop)
	c:RegisterEffect(e2)
end
function c515220005.filter(c)
	return c:IsSetCard(0x13) and c:IsAbleToHand()
end
function c515220005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c515220005.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c515220005.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c515220005.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if c:IsRelateToEffect(e) and c:IsFaceup() and g:GetCount()>0 and Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_MZONE,0)>0 
		and Duel.SelectYesNo(tp,515220005,0) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
function c515220005.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c515220005.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsAbleToChangeControler()
end
function c515220005.eqfilter(c,ec,tp)
	local eff={c:GetCardEffect(100407001)}
	if c:IsFacedown() or ((not c:IsSetCard(0x3013)) and not c:IsType(TYPE_MONSTER)) then return false end
	for _,te in ipairs(eff) do
		if te:GetValue()(ec,c,tp) then return true end
	end
	return false
end
function c515220005.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c515220005.filter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c515220005.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c515220005.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c515220005.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFirstTarget()
	if not tc1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c515220005.eqfilter,tp,LOCATION_MZONE,0,1,1,nil,tc1,tp)
	local tc2=g:GetFirst()
	if not tc2 then return end
	local te=tc2:GetCardEffect(100407001)
	if tc1:IsFaceup() and tc1:IsRelateToEffect(e) and tc1:IsControler(1-tp) then
		te:GetOperation()(tc2,te:GetLabelObject(),tp,tc1)
	end
end